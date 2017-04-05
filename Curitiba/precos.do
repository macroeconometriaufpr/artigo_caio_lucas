clear all 
cd "C:\Users\Caio\Documents\AdeTrabalho\price\Curitiba"

import excel "precos",firstrow clear

gen PRECOMEDIOREVEND=(PRECOMEDIOREVENDA/INPCFEV2016100)*100
gen PRECOMEDIODISTRIBUICA=(PRECOMEDIODISTRIBUICAO/INPCFEV2016100)*100

label var PRECOMEDIOREVEND "Preço Médio de Revenda"
label var PRECOMEDIODISTRIBUICA "Preço Médio de Distribuição"
label var MES " "
tw line PRECOMEDIOREVEND PRECOMEDIODISTRIBUICA MES if PRODUTO=="GASOLINA COMUM"
graph export "precos.png",replace

generate young = 0 
replace young = 1 if PRODUTO=="GASOLINA COMUM"

gen MARGEMMEDIAREVENDAA=(MARGEMMEDIAREVENDA/INPCFEV2016100)*100
keep MARGEMMEDIAREVENDAA MES young

reshape wide MARGEMMEDIAREVENDAA, i(MES) j(young) 

gen diffmargem = MARGEMMEDIAREVENDAA1/MARGEMMEDIAREVENDAA0
label var diffmargem "Razão entre Margens"

qui sum diffmargem 
local ccc=r(mean)
tw line diffmargem MES, yline(`ccc')




generate diff = MARGEMMEDIAREVENDAA1 - MARGEMMEDIAREVENDAA0

label var diff "Diferença entre Margens"
label var MARGEMMEDIAREVENDAA1 "Margem Média Gasolina"
label var MARGEMMEDIAREVENDAA0 "Margem Média Etanol"


line MARGEMMEDIAREVENDAA1 MES || line MARGEMMEDIAREVENDAA0 MES || line diff MES || lfit diff MES, legend(label(4 "Valores Ajustados"))     
graph export "margens.png", replace             
