#include 'totvs.ch'
#include 'fwmvcdef.ch'


/*/{Protheus.doc} U_GCTM001
    Cadastro de tipos de contratos (Modelo 1 e ADVPL MVC)
/*/
Function U_GCTM001
    
    Private aRotina := menudef()
    Private oBrowse := fwMBrowse():new()

    oBrowse:setAlias('Z50')
    oBrowse:setDescription('Tipos de Contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("Z50_TIPO == 'V' ","BR_AMARELO","Vendas" )
    oBrowse:addLegend("Z50_TIPO == 'C' ","BR_LARANJA","Compras" )
    oBrowse:addLegend("Z50_TIPO == 'S' ","BR_CINZA","Sem Integracao" )
    oBrowse:activate()

Return 

/*/{Protheus.doc} menudef
    Funcao pra ajudar na GCTM001 MVC
    /*/
Static Function menudef 

    Local aRotina := array(0)
    
    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'axPesqui'        OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.GCTM001' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.GCTM001' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.GCTM001' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.GCTM001' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'     ACTION 'VIEWDEF.GCTM001' OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'       ACTION 'VIEWDEF.GCTM001' OPERATION 9 ACCESS 0

    
Return aRotina


/*/{Protheus.doc} viewdef
    Construcao Interface Gráfica
    /*/

Static Function viewdef
    Local oView 
    Local oModel
    Local oStruct

    oStruct:=fwFormStruct(2, 'Z50')
    oModel:=fwLoadModel('GCTM001')
    oView:=fwFormView():new()
    
    oView:setModel(oModel)
    oView:addField('Z50MASTER', oStruct, 'Z50MASTER')
    oView:createHorizontalBox('BOXZ50', 100)
    oView:setOwnerView('Z50MASTER', 'BOXZ50')

Return oView


/*/{Protheus.doc} modeldef
    Regra de Negócio
    /*/

Static Function modeldef
    Local oModel
    Local oEstrutura
    Local aTrigger
    Local bModelPre := {|x| fnModPre(x)}
    Local bModelPos := {|x| fnModPos(x)}
    Local bCommit   := {|x| fnCommit(x)}
    Local bCancel   := {|x| fnCancel(x)}
    Local bFieldPre := {|oSubModel, cIdAction, cIdField, xValue| fnFieldPre(oSubModel,cIdAction,cIdField,xValue)}
    Local bFieldPos := {|oSubModel| fnFieldPos(oSubModel)}
    Local bFieldLoad:= {|oSubModel, lCopy| fnFieldLoad(oSubModel, lCopy)}

    oEstrutura := fwFormStruct(1, 'Z50')
    oModel := mpFormModel():new('MODEL_GCTM001', bModelPre, bModelPos, bCommit, bCancel)

    aTrigger := fwStruTrigger('Z50_TIPO', 'Z50_CODIGO', 'U_GCTT001()',.F.,Nil,Nil,Nil,Nil)
    oEstrutura:addTrigger(aTrigger[1],aTrigger[2],aTrigger[3],aTrigger[4])
    oEstrutura:setProperty('Z50_TIPO', MODEL_FIELD_WHEN,{||INCLUI})

    oModel:addFields('Z50MASTER',,oEstrutura,bFieldPre,bFieldPos,bFieldLoad)
    oModel:setDescription('Tipos de Contratos')
    oModel:setPrimaryKey({'Z50_FILIAL','Z50_CODIGO'})

Return oModel

/*/{Protheus.doc} fnModPre
    Função de pré validação do modelo de dados
    @type  Static Function
    
/*/
Static Function fnModPre (oModel)

    Local lValid := .T.
    Local nOperation := oModel:getOperation()
    Local cCampo := strtran(readvar(), "M->","")

    IF nOperation == 4
        IF cCampo == "Z50_DESCRI"
            //oModel:setErrorMessage('','','','','ERRO DE VALIDACAO','ESSE CAMPO NAO PODE SER EDITADO!')
            lValid := .T.
        EndIF
    EndIF

Return lValid


/*/{Protheus.doc} fnModPos
    Função de validação final do modelo de dados, tudo ok
    @type  Static Function
    
/*/
Static Function fnModPos (oModel)

    Local lValid := .T.
    Local cAliasSql := getNextAlias()
    Local lExist := .F.
    Local nOperation := oModel:getOperation()

    IF nOperation == 5

        BeginSQL alias cAliasSql
            SELECT * FROM %table:Z51% Z51
            WHERE Z51.%notdel%
            AND Z51_FILIAL = %exp:xFilial('Z51')%
            AND Z51_TIPO = %exp:Z50->Z50_CODIGO%
            LIMIT 1 
        EndSQL

        (cAliasSql)->(dbEval({||lExist:= .T.}), dbCloseArea())


        IF lExist
            oModel:setErrorMessage(,,,,"Registro já utilizado", "Esse registro nao pode ser excluido pois ja foi utilizado!")
            return .F.
        EndIF
    EndIF

Return lValid

/*/{Protheus.doc} fnCommit
    Funcao executada para gravacao dos dados
    @type  Static Function
    
/*/
Static Function fnCommit(oModel)
    
    Local lCommit := fwFormCommit(oModel)
    IF .Not. lCommit
        oModel:setErrorMessage(,,,,'Gravação dos dados não efetuada','Ocorreu um erro!')
    EndIf

Return lCommit


/*/{Protheus.doc} fnCancel
    Funcao executada para validacao do cancelamento dos dados
    @type  Static Function
    
/*/
Static Function fnCancel(oModel)
    
    Local lCancel := fwFormCancel(oModel)

Return lCancel


/*/{Protheus.doc} fnFieldPre
    Pre validacao do sub modelo
    @type  Static Function
   
/*/
Static Function fnFieldPre(oSubModel,cIdAction,cIdField,xValue)
    
    Local oModel := fwModelActive()
    Local lValid := .T.

    IF cIdAction == 'SETVALUE'
        IF cIdField == 'Z50_DESCRI'
            IF empty(xValue)
                oModel:setErrorMessage(,,,,'NAOVAZIO','ESTE CONTEUDO NAO PODE SER VAZIO')
                lValid := .F.
            EndIF
        EndIf
    EndIf

Return lValid


/*/{Protheus.doc} fnFieldPos
    Validacao tudo ok do sub modelo
    @type  Static Function
   
/*/
Static Function fnFieldPos(oSubModel)
    
    Local lValid := .T.

Return lValid

/*/{Protheus.doc} fnFieldLoad
    Validacao tudo ok do sub modelo
    @type  Static Function
   
/*/
Static Function fnFieldLoad(oSubModel,lCopy)
    
Return formLoadField(oSubModel,lCopy)















/*/{Protheus.doc} U_GCTT001
    fUNCAO PARA EXECUCAO DO GATILHO DE CÓDIGO
    @type  Function
     /*/
Function U_GCTT001
    
    Local cNovoCod := ''
    Local cAliasSQL := ''
    Local oModel := fwModelActive()
    Local nOperation := 0

    nOperation := oModel:getOperation()

    IF .not. (nOperation == 3 .or. nOperation == 9)
        cNovoCod := oModel:getModel('Z50MASTER'):getValue('Z50_CODIGO')
        return cNovoCod
    
    EndIF

    cAliasSQL := getNextAlias()

    BeginSQL alias cAliasSQL
        SELECT COALESCE(MAX(Z50_CODIGO),'00') Z50_CODIGO
        FROM %table:Z50% Z50
        WHERE Z50.%notdel%
        AND Z50_FILIAL = %exp:xFilial('Z50')%
        AND Z50_TIPO = %exp: M->Z50_TIPO%
    EndSQL

    (cAliasSQL)->(dbEval({|| cNovoCod := alltrim(Z50_CODIGO)}), dbCloseArea())

    IF cNovoCod == '00'
        cNovoCod := M->Z50_TIPO + '01'
    Else
        cNovoCod := soma1(cNovoCod)
    EndIF
Return cNovoCod
