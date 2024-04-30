observe_events_Mediation <- function(input, output, session, currentPage, values, SelectionMediation){
  
  # Button Prev variable type mediation
  observeEvent(input$Var_Med_Prev, {
    currentPage(MedB)
  })
  
  # Button Next variable type mediation
  observeEvent(input$Var_Med_Next, {
    if(input$TypExpMed == "J'en ai plusieurs" & input$TypOutcomeMed == "J'en ai plusieurs"){
      shinyalert("Exposition et outcome multiples", "Vous ne pouvez avoir qu'une seule exposition et un seul outcome. Considérez faire une analyse par combinaison exposition/outcome")
    }
    else if(input$TypExpMed == "J'en ai plusieurs") shinyalert("Exposition multiple", "Vous ne pouvez avoir qu'une seule exposition. Considérez de faire une analyse par exposition. Ou, si les expositions sont séquentielles, alors vous êtes dans le cas d'une variable intermédiaire. Dans ce cas, retournez au choix de l'objectif et modifiez votre réponse")
    else if (input$TypOutcomeMed == "J'en ai plusieurs") shinyalert("Outcome multiple", "Vous ne pouvez avoir qu'un seul outcome. Considérez de faire une analyse par outcome")
    else if (input$EffetTotVerif=="Non"){
      showModal(modalDialog(
        title = HTML("Avant de commencer une analyse de médiation, il est conseillé de vérifier qu'il y a bien un effet de l'exposition sur l'outcome car s'il n'y en a pas, l'analyse du rôle de la variable intermédiaire n'a dans la plupart des cas pas d'intérêt. Il existe cependant des cas où l'on ne trouve pas d'effet total de l'exposition sur l'outcome mais où l'on trouve un effet de médiation. Cela arrive si l'effet qui passe par la variable intermédiaire et celui qui ne passe pas par cette variable s'annulent. Gardez tout de même en tête que ce cas est plutôt rare.
        <br> <br> Souhaitez-vous d'abord vérifier l'effet total de l'exposition sur l'outcome (c'est-à-dire en omettant dans un premier temps l'intérêt pour votre variable intermédiaire) ou continuer directement à étudier le rôle de votre variable intermédiaire entre votre exposition et votre outcome (analyse de médiation) ?"),
        footer = tagList(actionButton("Retour_eff_tot", "Tester l'effet total"),
                         actionButton("Confirme_mediation", "Poursuivre sur une analyse de médiation"),
                         modalButton("Annuler"))
      )
      )
    } 
    
    else if (input$EffetTotVerif=="Oui_pb"){
      showModal(modalDialog(
        title = HTML("Dans la plupart des cas, s'il n'y a pas d'effet de  l'exposition sur l'outcome l'analyse de médiation par le facteur intermédiaire n'a pas d'intérêt. Il existe cependant des cas où l'on ne trouve pas d'effet total de l'exposition sur l'outcome mais où l'on trouve un effet de médiation. Cela arrive si l'effet qui passe par la variable intermédiaire et celui qui ne passe pas par cette variable s'annulent. Gardez tout de même en tête que ce cas est plutôt rare.
        <br> <br> Souhaitez-vous tout-de même étudier le rôle de la variable intermédiaire entre votre exposition et votre outcome (analyse de médiation) ? "),
        footer = tagList(actionButton("Confirme_mediation", "Poursuivre sur une analyse de médiation"),
                         modalButton("Annuler"))
      )
      )
    }
    #shinyalert("Effet total non vérifié", "Avant de commencer une analyse de médiation, vérifier dans un premier temps qu'il y a bien un effet total.
    #                                                \n Retournez en arrière à la question de la définition de votre objectif et sélectionnez uniquement l'effet de la classe sociale sur la mortalité.")
    else if (input$TypMediateurMed == "J'en ai plusieurs") shinyalert("Plusieurs médiateurs", "Pour le moment le cas de plusieurs médiateurs n'est pas géré par cette application") # A enlever quand on pourra le gérer
    else {
      values$TypExpMed <- input$TypExpMed
      values$TypMediateurMed <- input$TypMediateurMed
      EffetTotVerif <- input$EffetTotVerif
      values$TypOutcomeMed <- input$TypOutcomeMed
      currentPage(RepeteMed)
    } 
  })
  
  # Si la personne persiste à vouloir faire une analyse de médiation même sans effet total
  observeEvent(input$Confirme_mediation,{
    values$TypExpMed <- input$TypExpMed
    values$TypMediateurMed <- input$TypMediateurMed
    values$EffetTotVerif <- input$EffetTotVerif
    values$TypOutcomeMed <- input$TypOutcomeMed
    removeModal()
    currentPage(RepeteMed)
  })
  
  # Si la personne se dirige finalement sur un effet total
  observeEvent(input$Retour_eff_tot,{
    values$TypExpMed <- input$TypExpMed
    values$TypMediateurMed <- input$TypMediateurMed
    values$EffetTotVerif <- input$EffetTotVerif
    values$TypOutcomeMed <- input$TypOutcomeMed
    values$question2 <- "Non"
    removeModal()
    currentPage(Q1)
  })
  
  #Button Prev après questions sur la répétition
  observeEvent(input$Repet_Med_Prev, {
    currentPage(TypVarMed)
  })
  
  #Button Next après questions sur la répétition
  observeEvent(input$Repet_Med_Next, {
    values$ExpRepMed <- input$ExpRepMed
    values$MediateurRepMed <- input$MediateurRepMed
    values$OutRepMed <- input$OutRepMed
    
    if((input$ObjMedA1=="Oui" || input$ObjMedA2=="Oui" || input$ObjMedA3=="Oui") 
       & (input$ObjMedB1=="Non" & input$ObjMedB2=="Non" & input$ObjMedB3=="Non" & input$ObjMedB4=="Non")){
      currentPage(ConfuMed_CDE)
    }
    else currentPage(ConfuMed)
  })
  
  #Button Prev après questions sur la confusion
  observeEvent(input$Confu_Med_Prev, {
    currentPage(RepeteMed)
  })
  
  
  # observeEvent(input$question1_response, {
  #   values$ConfuInfluence<- input$ConfuInfluence
  #   
  #   # Vérifier si la réponse est "Oui"
  #   if (input$ConfuInfluence == "Oui") {
  #     # Afficher la question supplémentaire en utilisant renderUI
  #     output$QcondTemporalite <- renderUI({
  #       # Code HTML pour la question supplémentaire
  #       p(paste("Le temps entre l'observation de l'exposition et celle du médiateur est-il très court?"))
  #       radioButtons("additional_question_response", "",
  #                    choices = c("Oui", "Non"))
  #     })
  #   } else {
  #     # Masquer la question supplémentaire si la réponse n'est pas "Oui"
  #     output$QcondTemporalite <- renderUI(NULL)
  #   }
  # })
  
  #Button Next après questions sur la confusion
  observeEvent(input$Confu_Med_Next, {
    if(input$ConfuExpOutMed=="Non" | input$ConfuExpMedMed=="Non" | input$ConfuMedOutMed=="Non"){
      shinyalert("Facteurs de confusion manquant", "Vous devez faire apparaître tous les facteurs de confusion des trois relations
                 exposition/outcome, exposition/médiateur, médiateur/outcome sur votre DAG. \n
                 Rajoutez-les avant de poursuivre.")
    }
    else{
      values$ConfuExpOutMed = input$ConfuExpOutMed
      values$ConfuExpMedMed = input$ConfuExpMedMed
      values$ConfuMedOutMed = input$ConfuMedOutMed
      values$ConfuNonMesureMed= input$ConfuNonMesureMed
      values$ConfuInfluence = input$ConfuInfluence
      values$ShortTime = input$ShortTime
      values$add_hyp_cond = input$add_hyp_cond
      currentPage(CollidMed)
    }
  })
  
  #Button Next après questions sur la confusion dans le cas d'uniquement CDE
  observeEvent(input$Confu_Med_CDE_Next, {
    if(input$ConfuExpOutMed=="Non" | input$ConfuMedOutMed=="Non"){
      shinyalert("Facteurs de confusion manquant", "Vous devez faire apparaître tous les facteurs de confusion des trois relations
                 exposition/outcome, exposition/médiateur, médiateur/outcome sur votre DAG. \n
                 Rajoutez-les avant de poursuivre.")
    }
    else{
      values$ConfuExpOutMed = input$ConfuExpOutMed
      values$ConfuMedOutMed = input$ConfuMedOutMed
      values$ConfuNonMesureMed= input$ConfuNonMesureMed
      currentPage(CollidMed)
    }
  })
  
  #Button Prev après questions sur les colliders
  observeEvent(input$Verif_Collid_Med_Prev, {
    if((input$ObjMedA1=="Oui" || input$ObjMedA2=="Oui" || input$ObjMedA3=="Oui") 
       & (input$ObjMedB1=="Non" & input$ObjMedB2=="Non" & input$ObjMedB3=="Non" & input$ObjMedB4=="Non")){
      currentPage(ConfuMed_CDE)
    }
    else currentPage(ConfuMed)
  })
  
  #Button Next après questions sur les colliders
  observeEvent(input$Verif_Collid_Med_Next, {
    if(input$CollidExpOutMediation=="Oui" | input$CollidMedOut=="Oui"){
      shinyalert("Supprimez les colliders", "Les colliders peuvent apparaître sur le DAG MAIS, vous ne devez pas les inclure dans votre analyse car ils biaiseraient les résultats. Nous vous conseillons, pour la suite, de les supprimer de votre DAG afin d'être sûr de ne pas les inclure dans votre analyse \n 
                 Pour passer à la suite cochez 'Non'")
    }
    else{
      values$CollidExpOutMediation = input$CollidExpOutMediation
      values$CollidMedOut = input$CollidMedOut
      currentPage(PositiviteMed)
    }
  })
  
  # Button Prev après questions sur la positivité
  observeEvent(input$Posi_Med_Prev, {
    currentPage(CollidMed)
  })
  
  #Button Next après questions sur la positivité
  observeEvent(input$Posi_Med_Next, {
    values$PosiExpMed <- input$PosiExpMed
    values$PosiMedMed <- input$PosiMedMed
    currentPage(InteractionMed)
  })
  
  #Button Prev après questions sur l'interaction
  observeEvent(input$Interaction_Med_Prev, {
    currentPage(PositiviteMed)
  })
  
  #Button Next après questions sur l'interaction
  observeEvent(input$Interaction_Med_Next, {
    values$InteractionExpMed <- input$InteractionExpMed
    values$InteractionDirIndir <- input$InteractionDirIndir
    currentPage(ResumeMed)
  })
  
  #Button Prev après résumé des réponses
  observeEvent(input$Resume_Med_Prev, {
    currentPage(InteractionMed)
  })
  
  #Button Valider après résumé des réponses
  observeEvent(input$Valider_Med, {
    currentPage(RecoMed)
  })
  
  ### Texte questions confusion ###

  output$QconfusionExpOutMed <- renderText({
    paste("<b> Pensez-bien à tous les facteurs de confusion potentiels entre l'exposition <i>", ifelse(input$Expo=="", "", input$Expo), "</i> et l'outcome <i>", ifelse(input$Outcome=="", "", input$Outcome),"</i> </b>,
        i.e. toutes les variables qui affectent à la fois", ifelse(input$Expo=="", "l'exposition", input$Expo), "et", ifelse(input$Outcome=="", "l'outcome", input$Outcome),"<br>")}) 
  
  output$QconfusionExpMedMed <- renderText({
    paste("<b> Pensez-bien à tous les facteurs de confusion potentiels entre l'exposition <i>", ifelse(input$Expo=="", "", input$Expo), "</i> et le facteur intermédiaire <i>", ifelse(input$Mediateur=="", "", input$Mediateur),"</i> </b>,
        i.e. toutes les variables qui affectent à la fois", ifelse(input$Expo=="", "l'exposition", input$Expo), "et", ifelse(input$Mediateur=="", "le facteur intermédiaire", input$Mediateur),"<br>")}) 
  
  output$QconfusionMedOutMed <- renderText({
    paste("<b> Pensez-bien à tous les facteurs de confusion potentiels entre le facteur intermédiaire <i>
    ", ifelse(input$Mediateur=="", "", input$Mediateur), "</i> et l'outcome <i>", ifelse(input$Outcome=="", "", input$Outcome),"</i> </b>,
        i.e. toutes les variables qui affectent à la fois", ifelse(input$Mediateur=="", "le facteur intermédiaire", input$Mediateur), "et", ifelse(input$Outcome=="", "l'outcome", input$Outcome),"<br>")}) 
  
  output$ConfuInfluence <- renderText({
    paste("<b> Au moins un des facteurs de confusion entre le facteur intermédiaire <i>", input$Mediateur, "</i> et l'outcome <i>", input$Outcome,
    "</i> est-il influencé par l'exposition <i>", input$Expo,"</i> </b>,
    i.e. y a-t-il de la confusion intermédiaire ?")}) 
  
  ### Texte pour faire penser aux colliders ###
  output$QCollidExpOutMediation <- renderText({
    paste("<b> Votre graphe contient-il des variables qui sont influencées à la fois par ", ifelse(input$Expo=="", "l'exposition", input$Expo), "et par", ifelse(input$Outcome=="", "l'outcome", input$Outcome),"</b>,
        i.e. contient-il des colliders entre l'exposition et l'outcome ?")})
  
  output$QCollidMedOut <- renderText({
    paste("<b> Votre graphe contient-il des variables qui sont influencées à la fois par ", ifelse(input$Mediateur=="", "le facteur intermédiaire", input$Mediateur), "et par", ifelse(input$Outcome=="", "l'outcome", input$Outcome),"</b>,
        i.e. contient-il des colliders entre le médiateur et l'outcome ?")})
  
  ### Texte pour question sur la positivité de l'exposition ###
  output$QPosiExpMed <- renderText({
    "<b> Suspectez-vous que certaines combinaisons des facteurs de confusion correspondent uniquement à des individus exposés/non-exposés, </b>
          i.e. Y a-t-il des individus qui ne peuvent pas être exposés/non-exposés de par leurs caractéristiques ?"
  })
  
  ### Texte pour question sur la positivité du médiateur ###
  output$QPosiMedMed <- renderText({
    paste("<b> Suspectez-vous que certaines combinaisons des facteurs de confusion et de l'exposition conduisent systématiquement à la même valeur (ou à certaines valeurs) du facteur intermédiaire, </b> <br> 
          i.e. Y a-t-il des individus qui ne peuvent pas prendre certaines valeurs", ifelse(input$Mediateur=="", "du facteur intermédiaire", paste("de", input$Mediateur)), "de par leurs caractéristiques et leur", ifelse(input$Expo=="", "exposition", paste("valeur de", input$Expo)) ,"?")
  })
  
  ### Texte pour le terme d'interaction ###
  output$QInteractionExpMed <- renderText({
    paste("<b> Souhaitez-vous isoler l'éventuelle interaction entre ", ifelse(input$Expo=="", "l'exposition", input$Expo), "et", ifelse(input$Mediateur=="", "le facteur intermédiaire", input$Mediateur),", </b> <br>
        i.e. s'il y a une interaction entre l'exposition et le facteur intermédiaire, souhaitez-vous la faire ressortir dans un terme à part ?")})
  
  ###### Partie résumé des réponses #####
  output$VariableTypeMed <- renderTable({
    df <- data.frame("Variable" = c("Exposition", "Médiateur", "Outcome"),
               "Type" = c(input$TypExpMed, input$TypMediateurMed, input$TypOutcomeMed))
    SelectionMediation$VarType <- df
    df
  })
  
  # Contraintes sur les variables
  output$ContraintesMed <- renderTable({
    ExpRepet <- ifelse(input$ExpRepMed=="Oui", "Répétée", "Non répétée")
    MedRepet <- ifelse(input$MediateurRepMed=="Oui", "Répété", "Non répété")
    OutRepet <- ifelse(input$OutRepMed=="Oui", "Répété", "Non répété")
    df <- data.frame("Critère" = c("Exposition", "Médiateur", "Outcome"),
               "Réponse" = c(ExpRepet, MedRepet, OutRepet))
    SelectionMediation$ConstraintVar <- df
    df
  })
  
  # Contraintes sur les facteurs de confusion
  output$ContraintesMed2 <- renderTable({

    if((input$ObjMedA1=="Oui" || input$ObjMedA2=="Oui" || input$ObjMedA3=="Oui") 
       & (input$ObjMedB1=="Non" & input$ObjMedB2=="Non" & input$ObjMedB3=="Non" & input$ObjMedB4=="Non")){
      #On est dans le cas juste CDE, donc juste hyp 1 et 2 à vérifier donc moins de Q sur les facteurs de confusion
      df <- data.frame("Critère" = "Facteurs de confusion non mesurés",
                 "Réponse" = input$ConfuNonMesureMed)
      SelectionMediation$ConstraintConf <- df
      df
    }
    
    else{
      #On est dans le cas avec effets naturels et donc les 4 hyp à vérifiées -> toutes les Q sur les facteurs de confusion
      noms <- c("Facteurs de confusion non mesurés",
              "Facteur de confusion de la relation médiateur/outcome influencé par l'exposition")
      reponses <- c(input$ConfuNonMesureMed, input$ConfuInfluence)
      if(input$ConfuInfluence=="Oui"){
        noms <- c(noms, "Peu de temps entre observation de l'exposition et du médiateur")
        reponses <- c(reponses, input$ShortTime)
        if(input$ShortTime=="Non"){
          noms <- c(noms, "Après ajustement, pas de confusion non mesurée de la relation médiateur/outcome")
          reponses <- c(reponses, input$add_hyp_cond)
        }
      }
      df <- data.frame("Critère" = noms,
                "Réponse" = reponses)
      SelectionMediation$ConstraintConf <- df
      df
    }
  })
  
  # Contraintes sur la positivité
  output$ContraintesMed3 <- renderTable({
    noms <- c("Risque de non positivité de l'exposition (sachant les caractéristiques)",
              "Risque de non positivité du médiateur (sachant les caractéristiques et l'exposition)")
    reponses <- c(input$PosiExpMed, input$PosiMedMed)
    df <- data.frame("Critère" = noms,
               "Réponse" = reponses)
    SelectionMediation$ConstraintPos <- df
    df
  })
  
  # Terme d'interaction
  output$InteractionMed <- renderTable({
    noms <- "Terme d'interaction isolé"
    reponses <- input$InteractionExpMed
    if(input$InteractionExpMed=="Non"){
      noms <- c(noms, "Interaction incluse dans")
      reponses <- c(reponses, paste("Effet", input$InteractionDirIndir))
    }
    df <- data.frame("Critère" = noms,
               "Réponse" = reponses)
    SelectionMediation$Interaction <- df
    df
  })
  
  # Objectifs
  output$ObjectifResumeMed <- renderUI({
    exposition <- ifelse(input$Expo=="", "l'exposition", input$Expo)
    mediateur <- ifelse(input$Mediateur=="", "le médiateur", input$Mediateur)
    outcome <- ifelse(input$Outcome=="", "l'outcome", input$Outcome)
    texte <- "<ul>"
    if(input$question1=="Oui"){texte <- paste(texte, " <li> Effet de", exposition, "sur", outcome, "</li>")}
    if(input$ObjMedA1=="Oui"){texte <- paste(texte, "<br/> <li> Effet de", exposition, "sur", outcome, "après la mise en place d'une intervention qui affecte", mediateur, "</li>")}
    if(input$ObjMedA2=="Oui"){texte <- paste(texte, "<br/> <li> Effet de", exposition, "sur", outcome, "si on supprimait complètement", mediateur, "</li>")}
    if(input$ObjMedA3=="Oui"){texte <- paste(texte, "<br/> <li> Part de l'effet de ", exposition, "sur", outcome, "qui pourrait être éliminée en supprimant", mediateur, "pour tous les individus", "</li>")}
    if(input$ObjMedB1=="Oui"){texte <- paste(texte, "<br/> <li> Effet de", exposition, "sur", outcome, "qui passe par", mediateur, "</li>")}
    if(input$ObjMedB2=="Oui"){texte <- paste(texte, "<br/> <li> Effet de", exposition, "sur", outcome, "qui ne passe pas par", mediateur, "</li>")}
    if(input$ObjMedB3=="Oui"){texte <- paste(texte, "<br/> <li> Effet de", exposition, "sur", outcome, "si tous les individus avait la valeur de", mediateur, "d'une catégorie fixée", "</li>")}
    if(input$ObjMedB4=="Oui"){texte <- paste(texte, "<br/> <li> Part de l'effet de", exposition, "sur", outcome, "qui est due à l'effet de", exposition, "sur", mediateur, "</li>")}
    texte <- paste(texte, "</ul>")
    SelectionMediation$Obj <- texte
    HTML(texte)
  })
  
}