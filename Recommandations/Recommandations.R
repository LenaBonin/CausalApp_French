function(values){
  fluidRow(
    h3("Recommandations"),
    br(),
    p("D'après les réponses que vous avez fournies"),
    column(12,
           wellPanel(
             h4("Estimands"),
             DTOutput("Estimands")
           )),
    
    column(12,
           wellPanel(
             h4("Décomposition"),
             htmlOutput("DecompEffet")
           )),
    
    column(12,
           wellPanel(
             h4("Méthode d'estimation"),
             htmlOutput("MethodeRecommandee")
           )),
    
    column(12,
           wellPanel(
             h4("Hypothèses"),
             htmlOutput("AssumptionsMed")
           )),
    
    column(12,
           wellPanel(
             h4("Packages R"),
             htmlOutput("PackagesMed")
           )),
    
    actionButton("Recommandation_Prev", "< Précédent"),
    downloadButton("report_Med", "Télécharger les recommandations"),
    actionButton("Reinitialisation", "Réinitialiser le questionnaire")
  )
}