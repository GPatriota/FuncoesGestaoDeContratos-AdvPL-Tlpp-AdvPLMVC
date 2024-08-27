#include 'totvs.ch'
#include 'fwmvcdef.ch'
/*/{Protheus.doc} U_GCTM003
    Apontamentos de medições (Modelo 1 e ADVPL MVC)
/*/
Function U_GCTB003
    
    Private aRotina := fwLoadMenuDef('GCTM003MENUDEF')
    Private oBrowse := fwMBrowse():new()

    oBrowse:setAlias('Z53')
    oBrowse:setDescription('Apontamento de medicoes')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("LEFT(Z53_TIPO,1) == 'V' ","BR_AMARELO","Vendas" ,'1')
    oBrowse:addLegend("LEFT(Z53_TIPO,1) == 'C' ","BR_LARANJA","Compras",'1' )
    oBrowse:addLegend("LEFT(Z53_TIPO,1) == 'S' ","BR_CINZA","Sem Integracao",'1' )
    oBrowse:addLegend("Z53_STATUS $ 'A ' ","VERDE","Aberto",'2' )
    oBrowse:addLegend("Z53_STATUS == 'E' ","VERMELHO","Encerrado",'2' )
    oBrowse:activate()

Return 


/*/{Protheus.doc} menudef
    Funcao pra ajudar na GCTM002 MVC
