function(values){ 
  div(class = 'container',
      h3("Médiateurs et colliders"),
    htmlOutput("QMedExpOut"),
    img(src="Mediateur.png", width="35%"),
    radioButtons("MedExpOutTot","",
                 choices = c("Oui", "Non"),
                 selected = values$MedExpOutTot),
    
    br(),
    htmlOutput("QCollidExpOut"),
    img(src="Collider.png", width="30%"),
    radioButtons("CollidExpOutTot","",
                 choices = c("Oui", "Non"),
                 selected = values$CollidExpOutTot),
      
      actionButton("Verif_Tot_Prev", "< Précédent"),
      actionButton("Verif_Tot_Next", "Suivant >"),
      br()
  )
}
  
