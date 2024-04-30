observe_events_Recommandations_Tot <- function(input, output, session, currentPage, values, SelectionTotal){
  
  #Button Prev après les recommandations
  observeEvent(input$Recommandation_Tot_Prev, {
    currentPage(ResumeTot)
  })
  
  
  ###### PArtie Méthode ######
  #Fonction qui retourne la méthode générale la plus appropriée
  Methode <- reactive({
    if((input$ExpRepTot == "Non" | (input$ExpRepTot=="Oui" & input$ConfRepTot=="Non")) & input$OutRepTot=="Non"){
      Method <- "Régression"
    }
    else if(input$OutRepTot=="Non"){
      Method <- "G-méthodes"
    }
    else(
      Method <- "G-méthodes ou modèles mixtes (Modèles à effets fixes)"
    )
  })
  
  # Fonction qui retourne le texte complet de la recommandation de la méthode
  Methode_FullTxt <- reactive({
    Method <- Methode()
    if(Method=="Régression"){
      Method <- paste(Method, "ou méthode par score de propension (régression pondérée par l'inverse du score de propension (IPW), matching, stratification), ces méthodes permettent de simuler un essai randomisé.")
    }
    if(Method == "G-méthodes ou modèles mixtes (Modèles à effets fixes)"){
      Method <- paste("<b>", Method, "</b>",
                      "<br> <br> Si l'outcome au temps <i> t </i> n'est pas influencé par l'exposition au temps <i>t-1</i> et l'outcome au temps <i>t</i> n'influence pas l'exposition au temps <i>t+1</i>, et si de plus l'exposition au temps <i>t</i> n'influence aucun facteur de confusion au temps <i>t+1</i>, vous pouvez faire un modèle à effets fixes. Attention c'est une hypothèse forte et peu probable.<br>
                      Voir <a href = https://onlinelibrary.wiley.com/doi/full/10.1111/ajps.12417 target='_blank'> Imai, K., & Kim, I. S. (2019). <i>When should we use unit fixed effects regression models for causal inference with longitudinal data?. American Journal of Political Science,</i> 63(2), 467-490.</a> 
                      <br> et <a href = https://imai.fas.harvard.edu/research/files/FEmatch-twoway.pdf target='_blank'> Imai, K., & Kim, I. S. (2021). <i>On the use of two-way fixed effects regression models for causal inference with panel data. Political Analysis,</i> 29(3), 405-415.</a> pour plus de détails.
                      <br> Sinon, envisagez de ne considérer que la dernière mesure de l'outcome et d'utiliser les g-méthodes (g-computation ou modèles structurels marginaux).")
      if(input$TypExpTot=="Quantitative"){
        Method <- paste(Method, "Etant donné que votre exposition est continue, le plus simple sera d'utiliser la <b>g-computation</b>")
      }
    }
    if (Method=="G-méthodes"){
      if(input$TypExpTot=="Quantitative"){
        Method <- paste(Method, ": étant donné que votre exposition est continue, le plus simple sera d'utiliser la <b>g-computation</b>")
      }
      else{
        Method <- paste("<b>", Method, "</b>: en particulier la g-computation ou les modèles structurels marginaux
                        <br> Pour une estimation plus robuste, vous pouvez utiliser un estimateur à double robustesse comme le TMLE (Targeted Maximum Likelihood Estimator)")
      }
    }
    
    # Probleme de non positivité évidente
    if(input$QPosiTot=="Oui"){
      Method <- paste(Method,
                      "<br> <br> L'hypothèse de positivité nécessaire à l'analyse causale est violée, <b> vos résultats seront donc probablement biaisés </b>. <br>
                      Nous recommandons, si vous souhaitez tout de même faire l'analyse de faire de la <b> g-computation </b>, mais vous devrez rester très prudent dans l'interprétation des résultats")
    }
  })
  
  # Output de la partie méthode
  output$MethodeRecommandee_Tot <- renderUI({
    Method <- Methode_FullTxt()
    withMathJax(HTML(Method))
  })
  
  
  #### Partie Hypothèses ####
  
  ## Fonction qui retourne le texte a affiché dans la partie Hypothèses
  Assumptions_Tot_Fct <- reactive({
    Hyp <- "<b> 1- Positivité :</b> chaque individu a une probabilité non nulle d'être exposé / non-exposé <br>
    <b>2- Ignorabilité / Echangeabilité :</b> la valeur de l'outcome potentiel sous l'exposition <i> a </i> est indépendante de la valeur de l'exposition reçue <br>
    <b>3- Non-interférence :</b> l'outcome d'un individu n'est pas affecté par la valeur de l'exposition d'un autre individu <br>
    <b>4- Consistance :</b> l'outcome potentiel d'un individu sous une certaine valeur d'exposition correspond à la valeur de l'outcome qu'il aurait effectivement pris sous cette exposition <br>
     <br> <i>Remarque 1 : </i> ces hypothèses peuvent être formulées de façon conditionnelle, c'est-à-dire en rajoutant 'conditionnellement aux facteurs de confusion'. <br>
    <br> <i>Remarque 2 : </i> ces hypothèses sont difficiles à tester en pratique"
    
    #Positivité
    if(input$QPosiTot=="Oui"){
      Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué que l'hypothèse de positivité n'est probablement pas vérifiée dans vos données. <b>Vos résultats seront donc probablement biaisés et imprécis.</b>")
      if(Methode()=="Régression"){
        Hyp <- paste(Hyp, "<br> La régression va extrapoler des résultats. 
                     Si le problème de positivité est dû au fait qu'une combinaison est impossible en théorie, la régression extrapole sur des combinaisons impossibles/qui n'existent pas. Si le problème est dû à l'échantillon, elle extrapole les résultats sans avoir de données, les résultats risquent donc d'être imprécis.
                     <br> Concernant les scores de propension, certaines valeurs seront nulles, ce qui impliquera une division par 0 lors du calcul de l'IPW et le rendra donc impossible. Avec du matching, certains individus ne pourront pas être appariés et ne seront donc pas pris en compte dans l'analyse, ce qui entraînera une perte d'information et pourrait créer un biais de sélection. 
                     <br> Vous pouvez également utiliser de la g-computation/standardisation, mais comme pour la régression, cette méthode va extrapoler les résultats qui risquent donc d'être imprécis.")
      }
      else{
        Hyp <- paste(Hyp, "<br> Nous recommandons, si vous souhaitez tout de même faire l'analyse de faire de la <b> g-computation </b>, 
                    mais vous devrez rester très prudent dans l'interprétation des résultats. Si le problème de positivité est dû au fait qu'une combinaison est impossible en théorie, la g-computation extrapole sur des combinaisons impossibles/qui n'existent pas. Si le problème est dû à l'échantillon, le g-computation extrapole les résultats sans avoir de données, le résultats risque donc d'être imprécis.")
      }
    }
    
    else if(input$QPosiTot == "Je ne sais pas"){
      Hyp <- paste(Hyp, "<br> <br> Pour avoir une idée de la positivité de vos données, vous pouvez réaliser un tableau de contingence avec d'un côté les combinaisons possibles des facteurs de confusion et de l'autre l'exposition. Si aucune case ne comprend la valeur 0, la positivité est vérifiée. Plus le nombre de caractéristiques est grand et plus l'échantillon est petit, plus il y a de risque que l'hypothèse de positivité soit violée")
    }
    
    else{
      Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué ne pas suspecter de problème lié à la positivité. ")
    }
    
    # Facteurs de confusion non mesurés
    if(input$ConfuNonMesureTot=="Oui"){
      Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué avoir des facteurs de confusion non mesurés, vos résultats risquent donc d'être biaisés. 
                   Vous pouvez tout de même faire l'analyse et ensuite effectuer une analyse de sensibilité pour tenter d'estimer à quel point vos résultats sont sensibles à ces facteurs.")
    }
    else{
      Hyp <- paste(Hyp, "<br> <br> Vous avez indiqué ne pas avoir de facteurs de confusion non mesurés. 
      Ainsi, si vous ajustez bien vos modèles selon tous ces facteurs, vos modèles devraient être corrects. 
      Cependant, réfléchissez-y bien car il paraît peu probable d'avoir accès à tous les facteurs de confusion nécessaires en épidémiologie sociale. 
      Si vous pensez finalement qu'il est possible que vous en ayez, vous pouvez effectuer une analyse de sensibilité pour estimer à quel points vos résultats sont sensibles à ces facteurs non mesurés.")
    }
  })
  
  ## Output Hypothèses
  output$Assumptions_Tot <- renderUI({
    Hyp <- Assumptions_Tot_Fct()
    #sortie en format HTML
    HTML(Hyp)
  })
  
  ### Partie Packages
  ## Fonction qui retourne le texte de la partie Package
  Packages_Tot_Fct <- reactive({
    if (Methode()=="Régression"){
      Pac <- "Régression : fonction de base de r : <i> lm()</i> ou <i>glm()</i>
      <br> IPW : package <i> WeightIt </i>
      <br> Matching : package <i> MatchIt </i>
      <br> Stratification : vous pouvez créer les strates en utilisant la fonction <i>Quintiles</i> de R
      <br>
      <br> Vous pouvez aussi éventuellement utiliser la standardisation/g-computation. Pour cela vous pouvez utiliser le package <i>stdReg</i>"
    }
    else{
      Pac <- "G-computation/Standardisation : code à la main (voir tutoriel dans l'onglet Ressources)
      <br> Modèle structurel marginal (MSM) : utiliser le package <i> WeightIt </i> pour obtenir les poids, puis faire une regréssion de l'outcome sur l'exposition, pondérée par l'IPW"
    }
  })
  
  ## Output Package
  output$Packages_Tot <- renderUI({
    Pac <- Packages_Tot_Fct()
    HTML(Pac)
  })
  
  ### Téléchargement des recommandations au format html
  output$report_tot <- downloadHandler(
    filename = "Recommandations.html",
    content = function(file){
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "Recommandations_Tot.Rmd")
      file.copy("Recommandations_Tot.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      Obj <- SelectionTotal$Obj
      VarType <- SelectionTotal$VarType
      Cons <- SelectionTotal$Constraint
      Method <- Methode_FullTxt()
      Hyp <- Assumptions_Tot_Fct()
      Pac <- Packages_Tot_Fct()
      params <- list(Objective = HTML(Obj), VarType = VarType, Constraints = Cons,  Estimands = HTML("Effet total"), Methodes = withMathJax(HTML(Method)), Assumptions = HTML(Hyp), Packages = HTML(Pac))
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
  ### Reinitialisation du questionnaire
  observeEvent(input$Reinitialisation, {
    showModal(modalDialog(
      title = "Vous êtes sur le point de retourner au début du questionnaire. Vos réponses ne seront pas sauvegarder",
      footer = tagList(actionButton("Confirme_reinitialisation", "Confirmer"),
                       modalButton("Annuler"))
      )
    )
  })
  
  observeEvent(input$Confirme_reinitialisation, {
    values$question1 = NULL
    values$question2 = NULL             
                             
    # Effet total                
    values$ExpoTot = ""
    values$OutTot = ""               
    values$TypExpTot = NULL 
    values$TypOutcomeTot = NULL           
    values$ConfuTot = NULL
    values$ConfuNonMesureTot = NULL                  
    values$MedExpOutTot = NULL
    values$CollidExpOutTot = NULL             
    values$ExpRepTot = NULL
    values$ConfRepTot = NULL
    values$OutRepTot = NULL                        
    values$QPosiTot = NULL
                                    
    ##Médiation                
    values$Expo = "" 
    values$Mediateur = "" 
    values$Outcome=""                     
    values$ObjMedA1 = NULL
    values$ObjMedA2 = NULL
    values$ObjMedA3 = NULL #ObjMedA0 = NULL,                      
    values$ObjMedB1 = NULL 
    values$ObjMedB2 = NULL 
    values$ObjMedB3 = NULL 
    values$ObjMedB4 = NULL                       
    values$TypExpMed = NULL 
    values$TypMediateurMed = NULL 
    values$TypOutcomeMed = NULL 
    values$EffetTotVerif = NULL 
    values$RareOutcome=NULL                  
    values$ExpRepMed = NULL 
    values$MediateurRepMed = NULL 
    values$OutRepMed = NULL                 
    values$ConfuExpOutMed = NULL
    values$ConfuExpMedMed = NULL 
    values$ConfuMedOutMed = NULL 
    values$ConfuNonMesureMed = NULL 
    values$ConfuInfluence = NULL              
    values$ShortTime = NULL 
    values$add_hyp_cond = NULL          
    values$CollidExpOutMediation = NULL 
    values$CollidMedOut = NULL                     
    values$PosiExpMed = NULL 
    values$PosiMedMed = NULL                         
    values$InteractionExpMed = NULL 
    values$InteractionDirIndir = NULL
    
    removeModal()
    currentPage("Qprelim")
  })
  
}