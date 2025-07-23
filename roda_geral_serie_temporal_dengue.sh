#!/bin/bash
#
######################################################################
### Esse script tem como objetivo gerar a Serie temporal dos dados ### 
### de temperatura e Produto de Precipitacao SAMET/MERGE. É gerada ### 
### uma tabela para o Estudo da CLeusa/Matheus                     ###
###                                                                ###  
### Para EXECUTAR:                                                 ###
### ./roda_geral_serie_temporal_dengue.sh                          ###  
###                                                                ###
###                                                                ###
###                                                                ###  
### Elaborado Por: MARIO QUADRO  Adaptado por: MARIO QUADRO        ###
### FEB, 20th 2023                                                 ###
######################################################################
#
export LC_NUMERIC=en_US.UTF-8     ;# Comando para executar operacoes decimais
#
mt=(' ' 'JAN' 'FEB' 'MAR' 'APR' 'MAY' 'JUN' 'JUL' 'AUG' 'SEP' 'OCT' 'NOV' 'DEC')
dt=(' ' '31'  '28'  '31'  '30'  '31'  '30'  '31'  '31'  '30'  '31'  '30'  '31')

#
########################################################
# Definir os caminhos do scrips                        #
########################################################
#
path_scr=$HOME/scripts/scripts_dengue
#path_gra=/usr/share/opengrads/Contents
path_dat=$path_scr/out_data
path_out=$path_scr/cat_data
path_mer=/media/dados/operacao/merge/CDO.MERGE
path_sam=/media/dados/operacao/samet
#path_est=/media/dados/operacao/inmet/merged_file/BR
#
mkdir -p $path_scr
mkdir -p $path_dat
mkdir -p $path_out
#
rm -rf $path_dat/*.txt $path_dat/*.csv
rm -rf $path_out/*.txt $path_out/*.csv

#
list_estac=$path_scr/lista_cidades_pontoscentrais_sc.csv
arq_mer=${path_mer}/MERGE_CPTEC_DAILY_PREC_SB_2000_2022.nc
#
#########################################################################
#  Define Parametros
#########################################################################
#
rodscr=s
arqtime=$path_scr/time_exec.txt
#
echo "Tempo Inicial: " > ${arq_time}
date >> ${arq_time}
#
#########################################################################
###                     Define valor indefinido                   ###
#########################################################################
#
undef=-9999.0
#
########################################################
#  Define a Estacao Inicia (esti) e o Número de        # 
#  Estacoes (nest) a ser gerarado os dados             #
########################################################
#
#
esti=2
nest=`wc -l $list_estac | awk '{ print $1}'`
#
echo " Arq. Listagem das Estacoes -> "$list_estac
echo " Estação Inicial            -> "$esti
echo " No de Estacoes             -> "$nest
echo " Arquivo de dados MERGE     -> "$arq_mer
#
#
#exit

for (( j = ${esti}; j <= ${nest}; j++ ))
#for (( j = ${esti}; j <= 6; j++ ))
do
  
  cod=`head -$j $list_estac | tail -1 | cut -d"," -f2`
  lat=`head -$j $list_estac | tail -1 | cut -d"," -f3`
  lon=`head -$j $list_estac | tail -1 | cut -d"," -f4`
  #est=`head -$j $list_estac | tail -1 | cut -d"," -f7`
  mun=`head -$j $list_estac | tail -1 | cut -d"," -f5`
  arq_dat=$path_dat/merge_${cod}.txt
  arq_csv=$path_dat/merge_${cod}.csv
  #
  #echo "Estado            -> "$est
  echo "-----------------------------------------------------------"
  echo "Localidade, Latitude, Longitude -> "$mun" , "$lat" , "$lon
  
  #
  ########################################################
  #  Executa o CDO para os dados do MERGE               #
  ########################################################
  #
  cd $path_scr
  #

  cdo -outputtab,date,lon,lat,value -remapnn,"lon=${lon}_lat=${lat}" $arq_mer > $arq_dat
  #
  ########################################################
  #  Gera o Arquivo .csv
  ########################################################
  #
  cp -rf ${arq_dat} ${arq_csv}
  sed -i 's/ \+/,/g' ${arq_csv}  ;# Substitui um ou mais espaços por vírgula
  #sed -i "s/,DATA/DATA/g" ${arq_csv} ;# Retira o caracter vírgula da Primeira linha
  echo " Arquivo Gerado -> " ${arq_csv}

  #exit
   #
  cd $path_scr
 done

exit


#
#########################################################################
### WRITE FINAL TIME OF SCRIPT EXECUTION                              ###
#########################################################################
#
echo "Tempo Final: " >> ${arq_time}
date >> ${arq_time}
#
#########################################################################
### APAGA DADOS TEMPORÁRIOS                                          ###
#########################################################################
#
#rm -rf $path_dat/*.txt $path_dat/*.csv
rm -rf nohup.out





























 


exit
