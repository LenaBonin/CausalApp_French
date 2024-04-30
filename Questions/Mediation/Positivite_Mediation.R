# Questions pour voir s'il y a un risque évident que l'hypothèse de positivité ne soit pas vérifiée

function(values){ 
  div(class = 'container',
      h3("Positivité"),
      htmlOutput("QPosiExpMed"),
      radioButtons("PosiExpMed","",
                   choices = c("Oui", "Non", "Je ne sais pas"),
                   selected = values$PosiExpMed),
      
      br(),
      
      htmlOutput("QPosiMedMed"),
      radioButtons("PosiMedMed","",
                   choices = c("Oui", "Non", "Je ne sais pas"),
                   selected = values$PosiMedMed),
                   
                   br(),
                   
                   actionButton("Posi_Med_Prev", "< Précédent"),
                   actionButton("Posi_Med_Next", "Suivant >"),
                   br()
      )
}