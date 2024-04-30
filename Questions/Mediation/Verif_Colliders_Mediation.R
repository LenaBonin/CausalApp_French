function(values){ 
  div(class = 'container',
      h3("Colliders"),
      htmlOutput("QCollidExpOutMediation"),
      img(src="Collider_exp_out.png", width="30%"),
      radioButtons("CollidExpOutMediation","",
                   choices = c("Oui", "Non"),
                   selected = values$CollidExpOutMediation),
      
      br(),
      htmlOutput("QCollidMedOut"),
      img(src="Collider_Mediateur_Outcome.png", width="30%"),
      radioButtons("CollidMedOut","",
                   choices = c("Oui", "Non"),
                   selected = values$CollidMedOut),
      
      actionButton("Verif_Collid_Med_Prev", "< Précédent"),
      actionButton("Verif_Collid_Med_Next", "Suivant >"),
      br()
  )
}