function(values){
  fluidRow(
    h3("Recommandations"),
    br(),
    p("D'après les réponses que vous avez fournies"),
    column(12,
           wellPanel(
             h4("Estimands"),
             p("Effet total")
           )),
    
    
    column(12,
           wellPanel(
             h4("Méthode d'estimation"),
             htmlOutput("MethodeRecommandee_Tot")
           )),
    
    column(12,
           wellPanel(
             h4("Hypothèses"),
             htmlOutput("Assumptions_Tot")
           )),
    
    column(12,
           wellPanel(
             h4("Packages R"),
             htmlOutput("Packages_Tot")
           )),
    
    actionButton("Recommandation_Tot_Prev", "< Précédent"),
    downloadButton("report_tot", "Télécharger les recommandations"),
    actionButton("Reinitialisation", "Réinitialiser le questionnaire")
  )
}