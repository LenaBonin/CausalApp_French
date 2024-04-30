function(values){
  div(class = 'container',
      h3("et/ou du type :"),
      
      br(),
      htmlOutput("QMedB1"),
      radioButtons("ObjMedB1", "",
                   choices = c("Oui", "Non"),
                   selected = values$ObjMedB1),
      br(),
      htmlOutput("QMedB2"),
      radioButtons("ObjMedB2", "",
                   choices = c("Oui", "Non"),
                   selected = values$ObjMedB2),
      
      br(),
      htmlOutput("QMedB3"),
      radioButtons("ObjMedB3", "",
                   choices = c("Oui", "Non"),
                   selected = values$ObjMedB3),
      
      br(),
      htmlOutput("QMedB4"),
      radioButtons("ObjMedB4", "",
                   choices = c("Oui", "Non"),
                   selected = values$ObjMedB4),
      
      
      actionButton("MedB_Prev", "< Précédent"),
      actionButton("MedB_Next", "Suivant >")
      
  )
}