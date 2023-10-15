#------------------------------------------------------------------------------#
# Impunidad Cero
# proyecto:         Impunidad en desaparición
# fecha:            octubre 2023
# autoras:          Monserrat López y Helga Jáuregui
# num:              01 carga y limpieza de base de datos CNPJE
#------------------------------------------------------------------------------#

## Setup ----

Sys.setlocale("LC_ALL", "es_ES.UTF-8") # locale para Mac
# Sys.setlocale("LC_ALL", "Spanish") # locale para Windows
options(scipen = 999)

## Paquetes ----
library(pacman)
p_load(readxl, tidyverse, janitor)

## Cargar datos ----

# URLS de los tabulados de procuración de justicia (2017-2023)
urls <- c(
  "https://www.inegi.org.mx/contenidos/programas/cnpje/2023/tabulados/cnpje2023_proc_just.xlsx",
  "https://www.inegi.org.mx/contenidos/programas/cnpje/2022/tabulados/cnpje2022_proc_just.xlsx",
  "https://www.inegi.org.mx/contenidos/programas/cnpje/2021/tabulados/cnpje2021_proc_just.xlsx",
  "https://www.inegi.org.mx/contenidos/programas/cnpje/2020/tabulados/CNPJE2020_Proc_Just.xlsx",
  "https://www.inegi.org.mx/contenidos/programas/cnpje/2019/tabulados/CNPJE2019_M2.xlsx",
  "https://www.inegi.org.mx/contenidos/programas/cnpje/2018/tabulados/CNPJE2018_M2.xlsx",
  "https://www.inegi.org.mx/contenidos/programas/cnpje/2017/tabulados/CNPJE2017_M2.xlsx"
)

# Nombres de los archivos para descargar
local_files <- c(
  "01_data/cnpje2023_proc_just.xlsx",
  "01_data/cnpje2022_proc_just.xlsx",
  "01_data/cnpje2021_proc_just.xlsx",
  "01_data/cnpje2020_proc_just.xlsx",
  "01_data/cnpje2019_proc_just.xlsx",
  "01_data/cnpje2018_proc_just.xlsx",
  "01_data/cnpje2017_proc_just.xlsx"
)

# Descargar y salvar los archivos
for (i in seq_along(urls)) {
  download.file(urls[i], destfile = local_files[i], mode = "wb")
}

# Cargar bases de datos
df_2023 <- read_xlsx(local_files[1], sheet= 8, , range = "B5:I5140")%>% clean_names() %>% 
  mutate(total = as.numeric(total), clave = as.numeric(clave)) %>% 
  filter(row_number() != 1) %>% 
  select(clave, entidad_federativa, clave_delito_desglose, delito, total) %>% 
  rename("2022" = "total", "clave_delito" = "clave_delito_desglose")

df_2022 <- read_xlsx(local_files[2], sheet= 8, , range = "B5:I5140") %>% clean_names() %>% 
  mutate(total = as.numeric(total), clave = as.numeric(clave)) %>% 
  filter(row_number() != 1)%>% 
  select(clave, entidad_federativa, clave_delito_desglose, delito, total) %>% 
  rename("2021" = "total", "clave_delito" = "clave_delito_desglose")

df_2021 <- read_xlsx(local_files[3], sheet= 7, , range = "A4:G4988") %>% clean_names() %>% 
  mutate(total = as.numeric(total), clave = as.numeric(clave)) %>% 
  filter(row_number() != 1) %>% 
  select(clave, entidad_federativa, clave_delito, delito, total) %>%
  rename("2020" = "total")

df_2020 <- read_xlsx(local_files[4], sheet= 6, , range = "A4:G4988") %>% clean_names() %>% 
  mutate(total = as.numeric(total), clave = as.numeric(clave)) %>% 
  filter(row_number() != 1) %>% 
  select(clave, entidad_federativa, clave_delito, delito, total) %>%
  rename("2019" = "total")

# Juntar todas las bases de datos
delitos <- df_2023 %>% 
  left_join(df_2022) %>% 
  left_join(df_2021)  %>% 
  left_join(df_2020) 
  
# Guardar base de datos
write.csv(delitos, "02_out/delitos.csv", fileEncoding = "UTF-8", row.names = FALSE)







