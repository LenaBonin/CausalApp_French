observe_events_Recommandations <- function(input, output, session, currentPage, values, SelectionMediation){
  
  #Button Prev après les recommandations
  observeEvent(input$Recommandation_Prev, {
    currentPage(ResumeMed)
  })
  
  # Quantités à estimer: fonction qui retourne un tableau avec tous les effets possibles et TRUE ou FALSE selon qu'ils soient à estimer ou non, ainsi que l'abréviation utilisée pour les sections suivante
  Estimands <- reactive({
    TotalEffect <- !is.null(values$question1) & values$question1=="Oui"
    
    CDE <- !is.null(input$question2) & (!is.null(input$ObjMedA1) | !is.null(input$ObjMedA2))&
      values$question2=="Oui" & (values$ObjMedA1 == "Oui" | values$ObjMedA2=="Oui")
    
    PropEliminated <- !is.null(values$question2) & !is.null(values$ObjMedA3) & values$question2=="Oui" & values$ObjMedA3=="Oui"
    
    NDE <- !is.null(values$question2) & (!is.null(values$ObjMedB2) | !is.null(values$ObjMedB3))&
      values$question2=="Oui" & (values$ObjMedB2 == "Oui" | values$ObjMedB3=="Oui")
    
    NIE <- !is.null(values$question2) & !is.null(values$ObjMedB1) & values$question2=="Oui" & values$ObjMedB1=="Oui"
    
    PropMediated <- !is.null(values$question2) & !is.null(values$ObjMedB4) & values$question2=="Oui" & values$ObjMedB4=="Oui"
    
    if(PropMediated==T) NIE <- TotalEffect <- T  # On a besoin de ces mesures pour calculer PropMediated
    if(PropEliminated==T) CDE <- TotalEffect <- T # On a besoin de ces mesures pour calculer PropEliminated
    
    if(input$InteractionExpMed=="Oui" & (NDE==T | NIE==T)){
      # On isole le terme d'interaction
      MIE = T
      
      if(NDE==T){
        PNDE <- T
        TNDE <- F
      }
      else {
        PNDE <- F
        TNDE <- F
      }
      if(NIE==T){
        PNIE <- T
        TNIE <- F
      }
      else {
        PNIE <- F
        TNIE <- F
      }
    }
    else if(input$InteractionExpMed=="Non" & (NDE==T | NIE==T)){
      # On n'isole pas le terme d'interaction
      MIE = F
      
      if(input$InteractionDirIndir=="Direct"){
        if(NDE==T){
          TNDE <- T
          PNDE <- F
        }
        else{TNDE <- PNDE <- F}
        if(NIE==T){
          PNIE <- T
          TNIE <- F
        }
        else{PNIE <- TNIE <- F}
      }
      else{ # input$InteractionDirIndir ="Indirect"
        if(NDE==T){
          PNDE <- T
          TNDE <- F
        }
        else{TNDE <- PNDE <- F}
        if(NIE==T){
          TNIE <- T
          PNIE <- F
        }
        else{PNIE <- TNIE <- F}
      }
    }
    else{PNDE <- TNDE <- PNIE <- TNIE <- MIE <- F}
    
    
    Estimands <- data.frame(
      Effet = c("Effet total", "Effet direct controlé", "Proportion éliminée", "Effet naturel direct pur", "Effet naturel direct total",
                "Effet naturel indirect pur", "Effet naturel indirect total", "Proportion médiée", "Mediated interactive effect"),
      Abbreviation = c("TE", "CDE", "PropEliminated", "PNDE", "TNDE", "PNIE", "TNIE", "PropMediated", "MIE"),
      Estimation = c(TotalEffect, CDE, PropEliminated, PNDE, TNDE, PNIE, TNIE, PropMediated, MIE),
      Objectifs = c("Effet de l'exposition sur l'outcome",
                    "Effet de l'exposition sur l'outcome après la mise en place d'une intervention qui affecte le facteur intermédiaire \n
                    Effet de l'exposition sur l'outcome si on supprimait complètement le facteur intermédiaire",
                    "Part de l'effet de l'exposition sur l'outcome qui pourrait être éliminée en supprimant le facteur intermédiaire pour tous les individus",
                    "Effet de l'exposition sur l'outcome qui ne passe pas par le facteur intermédiaire",
                    "Effet de l'exposition sur l'outcome qui ne passe pas par le facteur intermédiaire",
                    "Effet de l'exposition sur l'outcome qui passe par le facteur intermédiaire",
                    "Effet de l'exposition sur l'outcome qui passe par le facteur intermédiaire",
                    "Part de l'effet de l'exposition sur l'outcome qui est due à l'effet de l'exposition sur le facteur intermédiaire",
                    "")
    ) 
    
  })
  
  # Estimands to be estimated
  Estimands_esti <- reactive({
    # Note: on utilise renderDT pour pouvoir afficher les retours à la lignes dans la colonnes "objectifs"
    # Comme je veux afficher un tableau simple sans toutes les options proposées par renderDT, je les supprime en les mettant FALSE
    
    Estimands <- Estimands() %>% 
      dplyr::filter(Estimation==T) %>%  # On filtre les effets qui sont à estimer
      dplyr::select((-Estimation))
    
    datatable(Estimands, escape = FALSE, rownames = FALSE, options = list(paging = F,
                                                                          searching=F,
                                                                          info=F,
                                                                          ordering = F,
                                                                          columnDefs = list(list(
                                                                            targets = "_all",
                                                                            render = JS(
                                                                              "function(data, type, row, meta) {",
                                                                              "  if(type === 'display') {",
                                                                              "    return data.replace(/\\n/g, '<br>');",
                                                                              "  } else {",
                                                                              "    return data;",
                                                                              "  }",
                                                                              "}"
                                                                            )
                                                                          ))))
  })
  
  # Output de la section Estimand
  output$Estimands <- renderDT({
    Estimands_esti()
 })
  
  ###### PArtie Décomposition #######
  ## Texte à afficher pour la décomposition 
  Decomp_Fct <- reactive({
    Estimands <- Estimands() %>%
      dplyr::filter(Estimation==T)
    
    AEstimer <- as.vector(Estimands$Abbreviation)
    Decomp <- ""
    
    if("TNIE" %in% AEstimer | "TNDE" %in% AEstimer) Decomp <- "<b>2-way decomposition :</b>"
    else if("PNDE"%in%AEstimer & "PNIE"%in%AEstimer) Decomp <- "<b>3-way decomposition :</b>"
    else if(("PNDE"%in%AEstimer | "PNIE"%in%AEstimer) & !("MIE"%in%AEstimer)) Decomp <- "<b>2-way decomposition :</b>"
    else if (("PNDE"%in%AEstimer | "PNIE"%in%AEstimer) & "MIE" %in% AEstimer) Decomp <- "<b>3-way decomposition :</b>"
    
    if("TNIE" %in% AEstimer | ("PNDE" %in% AEstimer & !("MIE" %in% AEstimer))){
      Decomp <- paste(Decomp, "$$TE = TNIE + PNDE$$")
      if(!("TNIE"%in%AEstimer)) Decomp <- paste(Decomp, "où TNIE est l'effet naturel indirect total <br> <br>")
      else if(!("PNDE"%in%AEstimer)) Decomp <- paste(Decomp, "où PNDE est l'effet naturel direct pur <br> <br>")
    }
    
    else if("TNDE" %in% AEstimer | ("PNIE" %in% AEstimer & !("MIE" %in% AEstimer))){
      Decomp <- paste(Decomp, "$$TE = TNDE + PNIE$$")
      if(!("TNDE"%in%AEstimer)) Decomp <- paste(Decomp, "où TNDE est l'effet naturel direct total <br> <br>")
      else if(!("PNIE"%in%AEstimer)) Decomp <- paste(Decomp, "où PNIE est l'effet naturel direct pur <br> <br>")
    } 
    
    else if(Decomp=="<b>3-way decomposition :</b>"){
      Decomp <- paste(Decomp, "$$TE = PNDE + PNIE + MIE$$")
      if(!("PNDE"%in%AEstimer)) Decomp <- paste(Decomp, "où PNDE est l'effet naturel direct pur <br> <br>")
      else if(!("PNIE"%in%AEstimer)) Decomp <- paste(Decomp, "où PNIE est l'effet naturel direct pur <br> <br>")
    } 
    
    if("PropEliminated" %in% AEstimer){
      Decomp <- paste(Decomp, "<br> <b>Proportion éliminée :</b> <br> <span style='margin-left: 50px;'> Echelle additive : </span> $$\\frac{TE - CDE}{TE}$$
                       <br> <span style='margin-left: 50px;'> Echelle risque relatif : </span> $$\\frac{OR^{TE} - OR^{CDE}}{OR^{TE}-1}$$")
    }
    if("PropMediated" %in% AEstimer){
      # Le choix de l'effet direct (PNDE ou TNDE) et indirect dépendent des réponses
      if("TNIE" %in% AEstimer){
        Decomp <- paste(Decomp, "<br> <b>Proportion médiée :</b> <br> <span style='margin-left: 50px;'> Echelle additive : </span> $$\\frac{TNIE}{TE}$$
                        <br> <span style='margin-left: 50px;'> Echelle risque relatif : </span> $$\\frac{OR^{PNDE}(OR^{TNIE}-1)}{OR^{PNDE}OR^{TNIE}-1}$$")
      }
      
      else{ #PNIE
        Decomp <- paste(Decomp, "<br> <b>Proportion médiée :</b> <br> <span style='margin-left: 50px;'> Echelle additive : </span> $$\\frac{PNIE}{TE}$$")
        #Then we must differentiate PNDE and TNDE
        if("PNDE"%in% AEstimer){
          Decomp <- paste(Decomp, "<br>  <span style='margin-left: 50px;'> Echelle risque relatif : </span> $$\\frac{OR^{PNDE}(OR^{PNIE}-1)}{OR^{PNDE}OR^{PNIE}-1}$$")
        }
        else{ #TNDE
          Decomp <- paste(Decomp, "<br>  <span style='margin-left: 50px;'> Echelle risque relatif : </span> $$\\frac{OR^{TNDE}(OR^{PNIE}-1)}{OR^{TNDE}OR^{PNIE}-1}$$")
        }
      }
    }
    Decomp
  })
  
  ## Output pour la décomposition
  output$DecompEffet <- renderUI({
    Decomp <- Decomp_Fct()
    withMathJax(HTML(Decomp))
  })
  
  # output$DecompEffet <- renderUI({
  #   Estimands <- Estimands() %>%
  #     dplyr::filter(Estimation==T)
  # 
  #   AEstimer <- as.vector(Estimands$Abbreviation)
  # 
  #   if("TNIE" %in% AEstimer | "TNDE" %in% AEstimer)
  #     Decomp <- "<br> 2-way decomposition :"
  #   else if("PNDE"%in%AEstimer & "PNIE"%in%AEstimer) Decomp <- "<br> 3-way decomposition :"
  # 
  #   if("TNIE" %in% AEstimer){
  #     Decomp <- paste(Decomp, "<br> <math> TE = TNIE + PNDE </math>")
  #   }
  #   else if("TNDE" %in% AEstimer) Decomp <- paste(Decomp, "<br> <math> TE = TNDE + PNIE </math>")
  #   else if(Decomp=="3-way decomposition :") Decomp <- paste(Decomp, "<br> <math> TE = PNDE + PNIE + MIE </math>")
  # 
  #   if("PropEliminated" %in% AEstimer){
  #     Decomp <- paste(Decomp, "<br> Proportion éliminée : <br> Echelle additive : $$(TE - CDE)/TE$$
  #                     <br> Echelle risque relatif : <math display='block'> <mfrac> <mn> <var>OR <sup> TE</sup></var> - <var>OR<sup>CDE</sup></var></mn> <mn><var>OR<sup>TE</sup></var></mn> </mfrac></math>")
  #   }
  # 
  #   HTML(Decomp)
  # })
  
  ###### PArtie Méthode ######
  
  # Fonction qui retourne la méthode générale
  Methode <- reactive({
    if(input$ExpRepMed == "Non" & input$MediateurRepMed=="Non" & input$OutRepMed=="Non"){
      Method <- "Régressions"
    }
    else if(input$OutRepMed=="Non"){
      Method <- "G-méthodes"
    }
    else(
      Method <- "G-méthodes ou modèles mixtes (Modèles à effets fixes)"
    )
    Method
  })
  
  # Fonction qui retourne le texte complet de la recommandation de la méthode
  Method_full_txt_Med <- reactive({
    Method <- Methode()
    
    # Si g-méthode, on propose les méthodes
    if (Method=="G-méthodes"){
      if(input$TypExpMed=="Quantitative" | input$TypMediateurMed=="Quantitatif"){
        Method <- paste(Method, ": étant donné que votre exposition et/ou votre médiateur sont continus, le plus simple sera d'utiliser la <b>g-computation</b>")
      }
      else{
        Method <- paste("<b>", Method, "</b>: en particulier la g-computation ou les modèles structurels marginaux
                        <br> Pour une estimation plus robuste, vous pouvez utiliser un estimateur double robuste comme le TMLE (Targeted Maximum Likelihood Estimator)")
      }
      #Si outcome binaire ou continu on peu proposé les modèles naturel
      if (input$TypOutcomeMed=="Binaire" | input$TypOutcomeMed=="Quantitatif"){
        Method <- paste(Method, "<br> <br> Vous pouvez aussi utiliser les modèles à effets naturels (Natural effect models)")
        
      } 
    }
    
    # Si outcome binaire et pas rare pas de régression logistique
    if(Method=="Régressions" && input$TypOutcomeMed=="Binaire" && input$RareOutcome=="Non"){
      Method <- paste(Method, "<br> Dans la deuxième régression: outcome expliqué par l'exposition, le médiateur et les facteurs de confusion, bien que votre outcome soit binaire, vous ne pouvez pas effectuer une régression logistique car celle-ci n'est valide
                      que dans le cas d'un outcome rare (à cause de la non-collapsibilité des odds-ratio). Vous pouvez effectuer une régression log-linéaire ou log-binomiale. <br> Si vous le préférez, vous pouvez, au lieu d'utiliser des régressions classiques, utiliser les g-méthodes. Vous pourrez alors les appliquer à partir d'une régression logistique.")
    }
    
    # Si outcome survie et pas rare pas de régression de Cox
    if(Method=="Régressions" && input$TypOutcomeMed=='Survie / Time-to-event' && input$RareOutcome=="Non"){
      Method <- paste(Method, "<br> Dans la deuxième régression : outcome expliqué par l'exposition, le médiateur et les facteurs de confusion, bien que votre outcome soit une survie, vous ne pouvez pas effectuer une regression de Cox car celle-ci n'est valide
                      que dans le cas d'un outcome rare (à cause de la non-collapsibilité des hazard-ratio). Vous devez effectué un accelerated failure time model. <br> Si vous le préférer, vous pouvez, au lieu d'utiliser des régressions classiques, utiliser les g-méthodes. Vous pourrez alors les aplliquer à partir d'une régression de Cox.")
    }
    
    if(Method=="G-méthodes ou modèles mixtes (Modèles à effets fixes)"){
      Method <- paste("<b>", Method, "</b> :",
                      "<br> <br> Nous vous conseillons de ne conserver que la dernière mesure de votre outcome et d'appliquer une g-méthode. Cela permettra de tenir compte de la dynamique causale, ce que ne permettra pas un modèle mixte. Cependant, cela se fait au détriment de tenir compte des facteurs de confusion constants non mesurés. Un modèle mixte permettra de prendre en compte les effets constants non mesurés mais ne tiendras pas compte de la dynamique causale, vos résultats seront donc probablement biaisés.
                      <br> Voir <a href = https://onlinelibrary.wiley.com/doi/full/10.1111/ajps.12417 target='_blank'> Imai, K., & Kim, I. S. (2019). <i>When should we use unit fixed effects regression models for causal inference with longitudinal data?. American Journal of Political Science,</i> 63(2), 467-490.</a> 
                      <br> et <a href = https://imai.fas.harvard.edu/research/files/FEmatch-twoway.pdf target='_blank'> Imai, K., & Kim, I. S. (2021). <i>On the use of two-way fixed effects regression models for causal inference with panel data. Political Analysis,</i> 29(3), 405-415.</a> pour plus de détails.
                      ")
    }
    
    # Probleme de non positivité évidente
    # if(input$PosiExpMed=="Oui" | input$PosiMedMed=="Oui"){
    #   Method <- paste(Method,
    #                   "<br> <br> L'hypothèse de positivité nécéssaire à l'analyse de médiation est violée, <b> vos résultats seront donc probablement biaisés et imprécis </b>. <br>
    #                   Nous recommandons, si vous souhaitez tout de même faire l'analyse de faire de la <b> g-computation </b>, mais vous devrez rester très prudent dans l'interprétation des résultats. Si le problème de positivité est dû au fait qu'une combinaison est impossible en théorie, la g-computation extrapole sur des combinaisons impossibles. Si le problème est dû à l'échantillon, le g-computation extrapole les résultats sans avoir de données, le résultats risque donc d'être imprécis.")
    # }
    return(Method)
  })
  
  
  ## Output de la section Méthode recommandée
  output$MethodeRecommandee <- renderUI({
    Method <- Method_full_txt_Med()
    HTML(Method)
  })
  
  
  ### Assumptions ###
  ## texte à afficher pour les hypothèses 
  Assumptions_Med_Fct <- reactive({
    Estimands <- Estimands() %>%
      dplyr::filter(Estimation==T)
    AEstimer <- as.vector(Estimands$Abbreviation)
    
    # Cas où l'on estime des effets naturels: il faut les 4 hypothèses
    if("PNIE" %in% AEstimer | "TNIE"%in% AEstimer | "PNDE"%in% AEstimer | "TNDE"%in% AEstimer){
      Hyp <- "1- Pas de facteur de confusion non mesuré / non contrôlé de la relation exposition/outcome <br>
      2- Pas de facteur de confusion non mesuré / non contrôlé de la relation médiateur/outcome <br>
      3- Pas de facteur de confusion non mesuré / non contrôlé de la relation exposition/médiateur <br>
      4- Pas de facteur de confusion de la relation médiateur/outcome qui soit une conséquence de l'exposition <br>
      De plus : Positivité et consistance"
      
      if("CDE" %in% AEstimer){
        Hyp <- paste(Hyp, "<br> <br> Pour l'effet direct contrôlé et la proportion éliminée, seules les deux premières hypothèses (ainsi que la positivité et la consistance) sont nécessaires.")
      }
      
      Hyp <- paste(Hyp, "<br> <br> <b> Vérification de ces hypothèses dans vos données :</b>")
      
      # Facteurs de confusion non mesurés
      if(input$ConfuNonMesureMed=="Oui"){
        Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué que certains facteurs de confusion sont non-mesurés dans vos données. Vous pouvez effectuer une analyse de sensibilité pour estimer à quel points vos résultats sont sensibles à ces facteurs non mesurés.")
      }
      else{
        Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué n'avoir aucun facteur de confusion non-mesuré dans vos données. Si vous ajustez bien selon tous les facteurs de confusion, les hypothèses 1,2 et 3 sont donc vérifiées. 
                     Cependant, réfléchissez-y bien car il semble peu probable de n'avoir aucun facteur de confusion non mesuré en épidémiologie sociale. <br>
                     Si vous pensez finalement qu'il est possible que vous en ayez, vous pouvez effectuer une analyse de sensibilité pour estimer à quel points vos résultats sont sensibles à ces facteurs non mesurés.")
      }
      
      # Verif hypothèse 4: cas non valide
      if(input$ConfuInfluence=="Oui"){
        Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué qu'au-moins un des facteurs de confusion de la relation médiateur/outcome était influencé par l'exposition. L'hypothèse 4 est donc violée.")
        
        if(input$ShortTime=="Oui"){
          Hyp <- paste(Hyp, "<br> Cependant le temps entre l'observation de l'exposition et celle du médiateur est court, 
                il est donc possible de faire l'hypothèse que le médiateur n'a pas le temps d'être influencé par ce facteur de confusion suite à l'exposition. Dans ce cas, l'hypothèse 4 peut être considérée comme non violée")
        }
        else if(input$add_hyp_cond=="Oui"){
          Hyp <- paste(Hyp, "<br> Selon vous, conditionnellement à l’exposition, le médiateur et le facteur de confusion intermédiaire, il n’y a pas de facteur de confusion non mesuré de la relation médiateur-outcome.
                       Via les méthodes indiquées ci-dessus, vous pouvez tout de même estimer des effets causaux, mais ce seront des effets interventionnels randomisés et non pas des effets conditionnels ou marginaux, leur interprétation sera donc un peu différente.")
        }
        else{
          Hyp <- paste(Hyp, "<br> <br> D'après vos réponses, l'hypothèse 4 n'est pas vérifiée. Si vous faite l'analyse, <b> vos résultats seront certainement biaisés </b>.")
        }
      }
      
      # Verif hypothèse 4: cas valide
      else{
        Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué qu'aucun facteur de confusion de la relation médiateur/outcome n'était influencé par l'exposition. Si cela est correct, l'hypothèse 4 serait donc vérifiée.")
      }
    }
    
    # Cas où l'on estime que l'effet direct contrôlé ou la proportion éliminée
    else{
      Hyp <- "1- Pas de facteur de confusion non mesuré / non contrôlé de la relation exposition/outcome <br>
      2- Pas de facteur de confusion non mesuré / non contrôlé de la relation médiateur/outcome <br>
      De plus: Positivité et consistance"
      Hyp <- paste(Hyp, "<br> <br> <b> Vérification de ces hypothèses dans vos données :</b>")
      
      # Verif hyp 1 et 2
      if(input$ConfuNonMesureMed=="Oui"){
        Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué que certains facteurs de confusion sont non-mesurés dans vos données. Vous pouvez effectuer une analyse de sensibilité pour estimer à quel points vos résultats sont sensibles à ces facteurs non mesurés.")
      }
      else{
        Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué n'avoir aucun facteur de confusion non-mesuré dans vos données. Si vous ajustez bien selon tous les facteurs de confusion, les hypothèses 1 et 2 sont donc vérifiées. 
                     Cependant, réfléchissez-y bien car il semble peu probable de n'avoir aucun facteur de confusion non mesuré en épidémiologie sociale. <br>
                     Si vous pensez finalement qu'il est possible que vous en ayez, vous pouvez effectuer une analyse de sensibilité pour estimer à quel point vos résultats sont sensibles à ces facteurs non mesurés.")
      }
    }
    
    # Vérif positivité
    if(input$PosiExpMed=="Oui" | input$PosiMedMed=="Oui"){
      Hyp <- paste(Hyp, "<br> <br> L'hypothèse de positivité est violée.")
      if (Methode()=="Régressions"){
        Hyp <- paste(Hyp, "<br> <b> vos résultats seront donc probablement biaisés et imprécis </b>. <br>
                     Les régressions vont extrapoler des résultats. 
                     Si le problème de positivité est dû au fait qu'une combinaison est impossible en théorie, les régressions extrapolent sur des combinaisons impossibles/qui n'existent pas. Si le problème est dû à l'échantillon, elles extrapolent les résultats sans avoir de données, le résultat risque donc d'être imprécis. ")
      }
      else{
        Hyp<- paste(Hyp, "<br> <b> vos résultats seront donc probablement biaisés et imprécis </b>. <br>
                      Nous recommandons, si vous souhaitez tout de même faire l'analyse de faire de la <b> g-computation </b>, 
                    mais vous devrez rester très prudent dans l'interprétation des résultats. Si le problème de positivité est dû au fait qu'une combinaison est impossible en théorie, la g-computation extrapole sur des combinaisons impossibles/qui n'existent pas. Si le problème est dû à l'échantillon, le g-computation extrapole les résultats sans avoir de données, le résultat risque donc d'être imprécis.")
      }
    }
    else if(input$PosiExpMed=="Je ne sais pas" | input$PosiMedMed=="Je ne sais pas"){
      Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué ne pas savoir s'il y a un risque que l'hypothèse de positivité soit violée. Pour en avoir une idée, vous pouvez réaliser deux tableaux de contingence : une combinaison des facteurs de confusion/exposition et une combinaison des facteurs de confusion et exposition / médiateurs. Si certaines cases sont égales à 0, alors l'hypothèse de positivité est violée.")
    }
    else{
      Hyp <- paste(Hyp, "<br> <br> Selon vous, l'hypothèse de positivité est vérifiée.")
    }
  })
  
  ## Output pour les hypothèses
  output$AssumptionsMed <- renderUI({
    Hyp <- Assumptions_Med_Fct()
    HTML(Hyp)
  })
  
  ### Partie packages ###
  ## Texte à afficher pour la partie Package
  Packages_Med_Fct <- reactive({
    if(Methode()=="Régressions"){
      if(input$TypOutcomeMed=="Binaire" && input$RareOutcome=="Non"){
        Pac <- "Vous pouvez faire la première régression avec les fonctions de base de R <i>lm()</i> ou <i>glm()</i>.
        Pour la deuxième régression (celle de l'outcome), vous pouvez utiliser la fonction <i>glm()</i> avec <i> family = binomial(link='log')</i> ou la fonction <i> logbin()</i> du package du même nom. <br>
        Il peut parfois y avoir des problèmes de convergence avec la fonction <i>glm </i> qui sont résolus avec <i>logbin()</i>, par contre cette dernière ne permet pas l'inclusion de terme d'interaction directement dans le modèle. Pour inclure une interaction avec cette dernière, il faut donc crée les variables correspondant à l'interaction à l'extérieur du modèle. Ainsi, s'il n'y a pas de problème de convergence, il est plus simple d'utiliser la fonction glm(). <br> <br>
        
        Vous pouvez ensuite faire les calculs à la mains à partir des coefficients des deux régressions.
      <br> <br>
      Une autre possibilité est d'utiliser la fonction <i>cmest()</i> du package <i> CMAverse </i> en choisissant la méthode <i> rb </i> (regression-based approach) et l'argument <i> yreg = 'loglinear'</i>. Cela vous retournera directement les estimations."
      }
      else if(input$TypOutcomeMed=='Survie / Time-to-event' && input$RareOutcome=="Oui"){
        Pac <- "Vous pouvez faire la première régression avec les fonctions de base de R <i>lm()</i> ou <i>glm()</i>.
        Pour la deuxième régression, vous pouvez utiliser le package <i> Survival </i> et la fonction <i>coxph()</i> <br>
        Vous pouvez ensuite faire les calculs à la main à partir des coefficients des deux régressions. <br>
        <br>
        Vous pouvez également utiliser la fonction <i> cmest()</i> du package <i> CMAverse </i> en choisissant la méthode <i> rb </i> (regression-based approach) et l'argument <i> yreg='coxph'</i>. Cela vous retournera directement les estimations."
      }
      
      else if(input$TypOutcomeMed=='Survie / Time-to-event' && input$RareOutcome=="Non"){
        Pac <- "Vous pouvez utiliser la fonction <i< cmest()</i> du package <i> CMAverse </i> en choisissant la méthode <i> rb </i> (regression-based approach) et l'argument <i> yreg='aft_exp'</i> ou <i> yreg='aft_weibull'</i>."
      }
      else{
        Pac <- "Vous pouvez faire les deux régressions avec les fonctions de base de R <i>lm()</i> ou <i>glm()</i> et ensuite faire les calculs à la mains à partir des coefficients
      <br> <br>
      Ou vous pouvez utiliser le package <i> CMAverse </i> en choisissant la méthode <i> rb </i> (regression-based approach) dans la fonction <i> cmest() </i>"
      }
      Pac <- paste(Pac, "<br> <br> pour plus d'information sur l'utilisation du package <i> CMAverse </i> : 
                   <a href = https://bs1125.github.io/CMAverse/index.html target = '_blank'> https://bs1125.github.io/CMAverse/index.html </a>")
    }
    
    else{
      Pac <- "Vous pouvez utiliser le package <i> CMAverse </i> <br>
      Modèle structurel marginal : choisissez le modèle <i> msm </i>
      <br> G-computation : choisissez le modèle <i> gformula </i>
      <br> Pour une estimation plus robuste, vous pouvez utiliser la méthode TMLE (targeted maximum likelihood estimation), vous pouvez le faire en utilisant le package <i> tmle </i>
      <br> <br> <i> Note : </i> la fonction msm n'est pas implémentée pour une exposition ou un médiateur continu"
      if((input$TypOutcomeMed=="Binaire" | input$TypOutcomeMed=="Quantitatif")){
        Pac <- paste(Pac, "
                     <br> <br>  Natural effect model : Package <i> CMAverse </i> choisissez le modèle <i> ne </i> ")
      }
    }
    Pac
  })
  
  ## Output de la partie Package
  output$PackagesMed <- renderUI({
    Pac <- Packages_Med_Fct()
    HTML(Pac)
  })
  
  
  ### Téléchargement des recommandations au format html
  output$report_Med <- downloadHandler(
    filename = "Recommandations.html",
    content = function(file){
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "Recommandations_Med.Rmd")
      file.copy("Recommandations_Med.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      Obj <- SelectionMediation$Obj
      Estimands <- Estimands_esti()
      Decomp <- Decomp_Fct()
      Method <- Method_full_txt_Med()
      Hyp <- Assumptions_Med_Fct()
      Pac <- Packages_Med_Fct()
      params <- list(Objective = HTML(Obj),
                     VarType = SelectionMediation$VarType,
                     ConstraintVar = SelectionMediation$ConstraintVar,
                     ConstraintConf = SelectionMediation$ConstraintConf,
                     ConstraintPos = ConstraintPos <- SelectionMediation$ConstraintPos,
                     Interaction = SelectionMediation$Interaction,
                     Estimands = Estimands, 
                     Decomposition = withMathJax(HTML(Decomp)),
                     Methodes = HTML(Method), 
                     Assumptions = HTML(Hyp), 
                     Packages = HTML(Pac))
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
  # ### Réinitialisation du questionnaire
  # observeEvent(input$Reinitialisation_Med, {
  #   values$question1 = NULL
  #   values$question2 = NULL             
  #   
  #   # Effet total                
  #   values$ExpoTot = ""
  #   values$OutTot = ""               
  #   values$TypExpTot = NULL 
  #   values$TypOutcomeTot = NULL           
  #   values$ConfuTot = NULL
  #   values$ConfuNonMesureTot = NULL                  
  #   values$MedExpOutTot = NULL
  #   values$CollidExpOutTot = NULL             
  #   values$ExpRepTot = NULL
  #   values$ConfRepTot = NULL
  #   values$OutRepTot = NULL                        
  #   values$QPosiTot = NULL
  #   
  #   ##Médiation                
  #   values$Expo = "" 
  #   values$Mediateur = "" 
  #   values$Outcome=""                     
  #   values$ObjMedA1 = NULL
  #   values$ObjMedA2 = NULL
  #   values$ObjMedA3 = NULL #ObjMedA0 = NULL,                      
  #   values$ObjMedB1 = NULL 
  #   values$ObjMedB2 = NULL 
  #   values$ObjMedB3 = NULL 
  #   values$ObjMedB4 = NULL                       
  #   values$TypExpMed = NULL 
  #   values$TypMediateurMed = NULL 
  #   values$TypOutcomeMed = NULL 
  #   values$EffetTotVerif = NULL 
  #   values$RareOutcome=NULL                  
  #   values$ExpRepMed = NULL 
  #   values$MediateurRepMed = NULL 
  #   values$OutRepMed = NULL                 
  #   values$ConfuExpOutMed = NULL
  #   values$ConfuExpMedMed = NULL 
  #   values$ConfuMedOutMed = NULL 
  #   values$ConfuNonMesureMed = NULL 
  #   values$ConfuInfluence = NULL              
  #   values$ShortTime = NULL 
  #   values$add_hyp_cond = NULL          
  #   values$CollidExpOutMediation = NULL 
  #   values$CollidMedOut = NULL                     
  #   values$PosiExpMed = NULL 
  #   values$PosiMedMed = NULL                         
  #   values$InteractionExpMed = NULL 
  #   values$InteractionDirIndir = NULL
  #   
  #   currentPage("Qprelim")
  # })
  
}

