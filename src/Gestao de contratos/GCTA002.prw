#include 'totvs.ch'
#include 'fwmvcdef.ch'
#include 'tbiconn.ch'

/*/{Protheus.doc} U_GCTA002
    (long_description)
    @type  Function
    
    /*/
Function U_CGTA002
    Local nOpcPad := 4
    Local aLegenda := {}
    aadd (aLegenda,{"Z51_TPINTE == 'V'","BR_AMARELO"})
    aadd (aLegenda,{"Z51_TPINTE == 'C'","BR_LARANJA"})
    aadd (aLegenda,{"Z51_TPINTE == 'S'","BR_CINZA"})
    Private cTitulo := 'Cadastro de contratos - Prototipo modelo 3'
    Private aRotina[0]
    

    aadd(aRotina,{'Pesquisar', 'axPesqui', 0,1})
    aadd(aRotina,{'Visualizar', 'U_GCTA002M', 0,2})
    aadd(aRotina,{'Incluir', 'U_GCTA002M', 0,3})
    aadd(aRotina,{'Alterar', 'U_GCTA002M', 0,4})
    aadd(aRotina,{'Excluir', 'U_GCTA002M', 0,5})
    aadd(aRotina,{"Legendas", "U_GCTA002L",0,6})

    dbSelectArea('Z51')
    dbSetOrder(1)

    mBrowse(,,,,alias(),,,,,nOpcPad,aLegenda)
    //Z51->(dbSetOrder(1),mBrowse(,,,,alias()),,,,,nOpcPad,aLegenda)

Return 

/*/{Protheus.doc} U_GCTA002L
    FUNCAO AUXILIAR PRA DESC DAS LEGENDAS
/*/
Function U_GCTA002L
    Local aLegenda := array(0)
    aadd (aLegenda, {"BR_AMARELO", "Contrato de Venda"})
    aadd (aLegenda, {"BR_LARANJA", "Contrato de Compra"})
    aadd (aLegenda, {"BR_CINZA", "Contrato Sem Integracao"})

Return brwLegenda ("Tipos de Contratos", "Legenda", aLegenda)


/*/{Protheus.doc} U_GCTA002M
    (long_description)
    @type  Function
    /*/
Function U_GCTA002M(cAlias,nReg,nOpc)
    Local oDlg
    Local aAdvSize := msAdvSize()
    Local aInfo := {aAdvSize[1],aAdvSize[2],aAdvSize[3],aAdvSize[4],3,3}
    Local aObj := {{100,120,.T.,.F.},{100,100,.T.,.T.},{100,010,.T.,.F.}}
    Local aPObj := msObjSize(aInfo,aObj)
    Local nStyle := GD_INSERT+GD_UPDATE+GD_DELETE
    Local nSalvar := 0
    Local bSalvar := {||if(obrigatorio(aGets,aTela), (nSalvar := 1, oDlg:end()), nil)}
    Local bCancelar := {||(nSalvar := 0, oDlg:end())}
    Local aButtons := array(0)
    Local aHeader := fnGetHeader()
    Local aCols := fnGetCols(nOpc,aHeader)

    Private oGet
    Private aGets := array(0)
    Private aTela := array(0)
    //Local nCampos := fCount()
    //Local cCampo := ''
    //Local xConteudo
    //Local x


    oDlg := tDialog():new(0,;               //coordenada inicial, linha inicial (pixels)
                          0,;               //coordenada inicial, coluna inicial
                          aAdvSize[6],;     //coordenada final, coluna final
                          aAdvSize[5],;     //coordenada final, linha final
                          cTitulo,;         //titulo da janela
                          Nil,;             //tudo q ta nulo Ã© pq n usa mais entao Ã© fixo
                          Nil,;
                          Nil,;
                          Nil,;
                          CLR_BLACK,;       //cor do texto
                          CLR_WHITE,;       //cor do fundo da tela
                          Nil,;
                          Nil,;
                          .T.)              //indica que as coordenadas serao em pixels


    //Abaixo terão duas formas de criar variáveis M
    //For x := 1 To nCampos

        //cCampo := fieldname(x)
        //xConteudo := if(nOpc == 3, criavar(cCampo,.T.,.T.),fieldget(x))
       // M->&(cCampo):= xConteudo

    //Next


    //Linhas abaixo servem para montagem do cabecalho
    regToMemory(cAlias,if(nOpc == 3, .T., .F.),.T.)
    M->Z51_NUMERO := iF(nOpc == 3, getSxeNum('Z51','Z51_NUMERO'), Z51->Z51_NUMERO)
    msmGet():new(cAlias,nReg,nOpc,,,,,aPObj[1])
    enchoicebar(oDlg,bSalvar,bCancelar,,aButtons)


    //Area de itens
    oGet := msNewGetDados():new(aPObj[2,1],; //coordenada inicial, linha inicial
                                aPObj[2,2],; // coordenada inicial, coluna inicial
                                aPObj[2,3],; // coordenada final, coluna final
                                aPObj[2,4],; // coordenada final, linha final
                                nStyle,;     // opcoes que podem ser executadas
                                'U_GCTA002V(1)' ,;     //parametro que valida se passa de linha ou nao
                                'U_GCTA002V(2)',;      //validacao final
                                '+Z52_ITEM',;//definicao do campo incremental
                                NIL,;       //lista dos campos que podem ser alterados
                                0,;         //valor fixo
                                9999,;      //total de linhas
                                'U_GCTA002V(3)',;     //valida cada campo preenchido
                                Nil,;       //fixo
                                'U_GCTA002V(4)',;     //valida se a linha pode ser deletada
                                oDlg,;      //Objeto proprietario
                                aHeader,;   //vetor com configs dos campos
                                aCols)     //vetor com conteudos dos campos                   

   oDlg:activate()
    
    IF nSalvar = 1
    //funcao pra gravar os dados
        fnGravar(nOpc,aHeader,oGet:aCols)
        IF __lsx8
            confirmSX8()
        EndIF
    
    Else
        IF __lsx8
            rollbackSX8()
        EndIF
    EndIF

Return 

/*/{Protheus.doc} U_GCTA002V
    vALIDA LINHAS DO GRID
    @type  Function
    
    /*/
Function U_GCTA002V(nOpcao)
    
    Local lValid := .T.

    IF nOpcao == 1
        lValid := oGet:chkObrigat(n)
    
    ElseIF nOpcao == 2
    ElseIF nOpcao == 3   
    ElseIF nOpcao == 4
    EndIF

Return lValid

/*/{Protheus.doc} fnGravar
    Funcao auxiliar para gravacao
    @type  Static Function
    
/*/
Static Function fnGravar(nOpc, aHeader, aCols)

    Local x,y
    Local nCampos
    Local cCampo
    Local xConteudo
    Local aLinha[0]
    Local lDelete
    Local lFound 

    BEGIN TRANSACTION

    DO CASE
        CASE nOpc == 3 // inclusao
            //cabeçalho
            nCampos := Z51->(fCount())
            Z51->(reclock(alias(),.T.))
                For x:= 1 To nCampos
                    Z51->&(fieldname(x)) := M->&(fieldname(x))
                Next

                Z51->Z51_FILIAL := xFilial('Z51')
            Z51->(msunlock())
            
            //itens
            For x := 1 To Len(aCols)
                aLinha := aClone(aCols[x])
                lDelete := aLinha[Len(aLinha)]
                
                If lDelete
                    Loop
                EndIf

                Z52->(reclock(alias(),.T.))
                    For y := 1 To Len(aHeader)
                        cCampo := aHeader[y,2]
                        xConteudo := aCols[x,y]
                        Z52->&(cCampo) := xConteudo                    
                    Next
                
                    Z52->Z52_FILIAL := xFilial('Z52')
                    Z52->Z52_NUMERO := M->Z51_NUMERO
                Z52->(msunlock())

            Next

        CASE nOpc == 4 // alteracao
            //cabecalho
            nCampos := Z51->(fCount())
            Z51->(dbSetOrder(1),dbSeek(xFilial(alias())+M->Z51_NUMERO))

            lFound := Z51->(Found())

            Z51->(reclock(alias(),.F.))
                For x:= 1 To nCampos
                    Z51->&(fieldname(x)) := M->&(fieldname(x))
                Next

                Z51->Z51_FILIAL := xFilial('Z51')
            Z51->(msunlock())

            //itens 
            For x := 1 To Len(aCols)
            //posicionando no registro
                Z52->(dbSetOrder(1), dbSeek(xFilial(alias())+M->Z51_NUMERO+aCols[x,1]))
                lFound := Z52->(Found())

                aLinha := aClone(aCols[x])
                lDelete := aLinha[Len(aLinha)]
                
                If lDelete
                    
                    IF lFound
                        Z52->(reclock(alias(),.F.),dbDelete(), msunlock())
                    EndIf
                    Loop
                EndIf

                lInc := .not. lFound
                

                Z52->(reclock(alias(),lInc))
                    For y := 1 To Len(aHeader)
                        cCampo := aHeader[y,2]
                        xConteudo := aCols[x,y]
                        Z52->&(cCampo) := xConteudo                    
                    Next
                
                    Z52->Z52_FILIAL := xFilial('Z52')
                    Z52->Z52_NUMERO := M->Z51_NUMERO
                Z52->(msunlock())

            Next

            


        CASE nOpc == 5 // exclusao

            Z52->(dbSetOrder(1), dbSeek(xFilial(alias())+Z51->Z51_NUMERO))

            While .not. Z52->(eof()) .and. Z52->(Z52_FILIAL+Z52_NUMERO) == Z51->(Z51_FILIAL+Z51_NUMERO)
                Z52->(reclock(alias(),.F.),dbDelete(), msunlock(),dbSkip()) 
            Enddo

            Z51->(reclock(alias(),.F.),dbDelete(), msunlock())

    END CASE

    END TRANSACTION
Return 

/*/{Protheus.doc} fnGetHeader
    Funcao que gera configs dos campos da msnewgetdados
    @type static function
    @
/*/
Static Function fnGetHeader
    Local aHeader := array(0)
    Local aAux    := array(0)

    SX3->(dbSetOrder(1),dbSeek("Z52"))
    
    While .not. SX3->(eof()) .and. SX3->X3_ARQUIVO == 'Z52'

        IF alltrim(SX3->X3_CAMPO) $ 'Z52_FILIAL|Z52_NUMERO'
            SX3->(dbSkip())
            Loop
        EndIF

        aAux:= {}
        aadd(aAux, SX3->X3_TITULO)
        aadd(aAux, SX3->X3_CAMPO)
        aadd(aAux, SX3->X3_PICTURE)
        aadd(aAux, SX3->X3_TAMANHO)
        aadd(aAux, SX3->X3_DECIMAL)
        aadd(aAux, SX3->X3_VALID)
        aadd(aAux, SX3->X3_USADO)
        aadd(aAux, SX3->X3_TIPO)
        aadd(aAux, SX3->X3_F3)
        aadd(aAux, SX3->X3_CONTEXT)
        aadd(aAux, SX3->X3_CBOX)
        aadd(aAux, SX3->X3_RELACAO)
        aadd(aAux, SX3->X3_WHEN)
        aadd(aAux, SX3->X3_VISUAL)
        aadd(aAux, SX3->X3_VLDUSER)
        aadd(aAux, SX3->X3_PICTVAR)
        aadd(aAux, SX3->X3_OBRIGAT)

        aadd(aHeader,aAux)
        SX3->(dbSkip())
    
    Enddo

Return aHeader


/*/{Protheus.doc} fnGetCols
    Funcao que gera conteudos dos campos da msnewgetdados
    @type static function
    @
/*/
Static Function fnGetCols (nOpc, aHeader)
    Local aCols := array(0)
    Local aAux := array(0)
    
    If nOpc == 3 // qnd se trata de inclusao
        aEval(aHeader, {|x| aadd(aAux,criavar(x[2],.T.))})
        aAux[1] := '001'
        aadd(aAux,.F.)
        aadd(aCols,aAux)
        return aCols
    EndIF

    //se chegou ate aqui é pq passou pela cima, portanto é qlqr uma menos inclusao
    Z52->(dbSetOrder(1), dbSeek(Z51->(Z51_FILIAL+Z51_NUMERO)))

    While .not. Z52->(eof()) .and. Z52->(Z52_FILIAL+Z52_NUMERO) == Z51->(Z51_FILIAL+Z51_NUMERO)
        aAux := {}
        aEval(aHeader,{|x| aadd(aAux,Z52->&(x[2]))})
        aadd(aAux,.F.)
        aadd(aCols,aAux)
        Z52->(dbSkip())

    Enddo

Return aCols
