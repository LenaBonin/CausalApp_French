function(values){
  div(class = 'container',
      h3("Plus précisément, votre objectif est-il du type :"),
      # br(),
      # htmlOutput("QMedA0"),
      # radioButtons("ObjMedA0", "",
      #              choices = c("Oui", "Non"),
      #              selected = values$ObjMedA0),
      br(),
      htmlOutput("QMedA1"),
      radioButtons("ObjMedA1", "",
                   choices = c("Oui", "Non"),
                   selected = values$ObjMedA1),
      br(),
      htmlOutput("QMedA2"),
      radioButtons("ObjMedA2", "",
      choices = c("Oui", "Non"),
      selected = values$ObjMedA2),
      
      br(),
      htmlOutput("QMedA3"),
      radioButtons("ObjMedA3", "",
                   choices = c("Oui", "Non"),
                   selected = values$ObjMedA3),
      
      
      actionButton("MedA_Prev", "< Précédent"),
      actionButton("MedA_Next", "Suivant >")
      
  )
}