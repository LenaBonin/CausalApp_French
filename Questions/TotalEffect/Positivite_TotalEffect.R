# Question pour voir s'il y a un risque évident que l'hypothèse de positivité ne soit pas vérifiée

function(values){ 
  div(class = 'container',
      h3("Positivité"),
      radioButtons("QPosiTot","Suspectez-vous que certaines combinaisons des facteurs de confusions correspondent uniquement à des individus exposés/non-exposés,
                   i.e Y a-t-il des individus qui ne peuvent pas être exposés/non-exposés de par leurs caractéristiques ?",
                   choices = c("Oui", "Non", "Je ne sais pas"),
                   selected = values$QPosiTot),
      
      br(),
      
      actionButton("Posi_Tot_Prev", "< Précédent"),
      actionButton("Posi_Tot_Next", "Suivant >"),
      br()
  )
}