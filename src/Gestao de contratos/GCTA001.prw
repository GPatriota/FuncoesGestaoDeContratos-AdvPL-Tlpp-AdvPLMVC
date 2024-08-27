#include 'totvs.ch'

/*/{Protheus.doc} U_GCTA001
    Cadastro de contratos (Modelo 1 e ADVPL tradicional)
/*/
Function U_GCTA001
    Local nOpcPad := 4
    Local aLegenda := {}

    aadd (aLegenda,{"Z50_TIPO == 'V'","BR_AMARELO"})
    aadd (aLegenda,{"Z50_TIPO == 'C'","BR_LARANJA"})
    aadd (aLegenda,{"Z50_TIPO == 'S'","BR_CINZA"})
    Private cCadastro := 'Cadastro de tipos de contratos'
    Private aRotina := {}

    aadd(aRotina, {"Pesquisar", "axPesqui",0,1})
    aadd(aRotina, {"Visualizar", "axVisual",0,2})
    aadd(aRotina, {"Incluir", "axInclui",0,3})
    aadd(aRotina, {"Alterar", "axAltera",0,4})
    aadd(aRotina, {"Excluir", "axDeleta",0,5})
    aadd(aRotina,{"Legendas", "U_GCTA001L",0,6})

    dbSelectArea('Z50')
    dbSetOrder(1)

    mBrowse(,,,,alias(),,,,,nOpcPad,aLegenda)

Return

/*/{Protheus.doc} U_GCTA001L
    FUNCAO AUXILIAR PRA DESC DAS LEGENDAS
/*/
Function U_GCTA001L
    Local aLegenda := array(0)
    aadd (aLegenda, {"BR_AMARELO", "Contrato de Venda"})
    aadd (aLegenda, {"BR_LARANJA", "Contrato de Compra"})
    aadd (aLegenda, {"BR_CINZA", "Contrato Sem Integracao"})

Return brwLegenda ("Tipos de Contratos", "Legenda", aLegenda)


/*/{Protheus.doc} U_GCTA001D
    Função de deletar personalizada
    /*/
Function U_GCTA001D(cAlias, nReg, nOpc)
    
    Local cAliasSql := getNextAlias()
    Local lExist := .F.
    
    BeginSQL alias cAliasSql
        SELECT * FROM %table:Z51% Z51
        WHERE Z51.%notdel%
        AND Z51_FILIAL = %exp:xFilial('Z51')%
        AND Z51_TIPO = %exp:Z50->Z50_CODIGO%
        LIMIT 1 
    EndSQL

    (cAliasSql)->(dbEval({||lExist:= .T.}), dbCloseArea())

    IF lExist
        fwAlertWarning("Tipo de contrato já utilizado", "ATENÇÃO!")
        return .F.
    EndIF

Return axDeleta(cAlias, nReg, nOpc)
