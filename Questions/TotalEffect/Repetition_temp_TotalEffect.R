function(values){ 
  div(class = 'container',
      h3("Confusion intermédiaire et mesures répétées"),
      radioButtons("ExpRepTot","La mesure de votre exposition est-elle répétée dans le temps ?",
                  choices = c("Oui", "Non"), 
                  selected = values$ExpRepTot),
    
      br(),
      
      conditionalPanel(
        condition = "input.ExpRepTot == 'Oui'",
        div(
          class = "additional-question",
          radioButtons("ConfRepTot","La mesure d'au moins un de vos facteurs de confusion est-elle répétée dans le temps ?",
                       choices = c("Oui", "Non"),
                       selected = values$ConfRepTot)
        )
      ),
    
      br(),
      radioButtons("OutRepTot","La mesure de votre outcome est-elle répétée dans le temps ?",
                  choices = c("Oui", "Non"),
                  selected = values$OutRepTot),
    
      actionButton("Repet_Tot_Prev", "< Précédent"),
      actionButton("Repet_Tot_Next", "Suivant >"),
      br()
    )
}
