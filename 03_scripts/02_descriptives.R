#------------------------------------------------------------------------------#
# Impunidad Cero
# proyecto:         Impunidad en desaparición
# fecha:            octubre 2023
# autoras:          Monserrat López y Helga Jáuregui
# num:              02 descriptivos
#------------------------------------------------------------------------------#

## Setup ----
Sys.setlocale("LC_ALL", "es_ES.UTF-8") # locale para Mac
# Sys.setlocale("LC_ALL", "Spanish") # locale para Windows
options(scipen = 999)

# Delitos nacionales
delitos <- read_csv("02_out/delitos.csv") %>% 
  filter(entidad_federativa == "Estados Unidos Mexicanos")

# Selección de delitos
delitos_selected <- delitos %>% 
  filter(clave_delito %in% c(20100, 20200, 20300, 20400, 20500, 20700))

# Hacer un nuevo tipo de delito que se llame secuestro que sea igual a a la suma de todos los tipos de secuestro
secuestro <- delitos %>% 
  filter(grepl("Secuestro", delito, ignore.case = TRUE))

# Sumar
secuestro <- secuestro %>%
  group_by(clave, entidad_federativa) %>%
  summarize(
    `2022` = sum(`2022`, na.rm = TRUE),
    `2021` = sum(`2021`, na.rm = TRUE),
    `2020` = sum(`2020`, na.rm = TRUE),
    `2019` = sum(`2019`, na.rm = TRUE)) %>% 
  mutate(clave_delito = 20100, delito = "Secuestro") %>% 
  select(clave,entidad_federativa, clave_delito, delito, "2022", "2021", "2020", "2019")

# Juntar ambas bases
delitos_selected <- bind_rows(delitos_selected, secuestro) %>% 
  pivot_longer(cols = c("2022", "2021", "2020", "2019"), names_to = "Year", values_to = "Value")

# Paleta
palette <- c("#003f5c", "#374c80", "#7a5195", "#bc5090", "#ef5675","#ff764a", "#ffa600")

# Gráfica
ggplot(delitos_selected, aes(x = Year, y = Value, group = delito, color = delito, label = Value)) +
  geom_line() +
  geom_point(size = 3, show.legend = FALSE) +
  scale_color_manual(values = palette) +
  labs(
    x = "Año",
    y = "Total",
    title = "Delitos registrados en las carpetas de investigación iniciadas",
    subtitle = "Cifras nacionales"
  ) +
  theme_minimal()
