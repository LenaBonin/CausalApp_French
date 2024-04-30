function(values){ 
  div(class = 'container',
      h3("Confusion intermédiaire et mesures répétées"),
      radioButtons("ExpRepMed",paste("La mesure de votre exposition", values$Expo,  "est-elle répétée dans le temps ?"),
                   choices = c("Oui", "Non"), 
                   selected = values$ExpRepMed),
      
      br(),
      radioButtons("MediateurRepMed",paste("La mesure de votre facteur intermédiaire", values$Mediateur, "est-elle répétée dans le temps ?"),
                   choices = c("Oui", "Non"),
                   selected = values$MediateurRepMed),
      
      br(),
      radioButtons("OutRepMed",paste("La mesure de votre outcome", values$Outcome, "est-elle répétée dans le temps ?"),
                                           choices = c("Oui", "Non"),
                                           selected = values$OutRepMed),
                   
      actionButton("Repet_Med_Prev", "< Précédent"),
      actionButton("Repet_Med_Next", "Suivant >"),
      br()
  )
}