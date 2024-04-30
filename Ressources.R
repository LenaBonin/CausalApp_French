fluidRow(
  column(12,
         HTML("<b> Graphes acycliques dirigés (DAGs) : </b>
             <br> Cours/Vidéos en ligne : <a href =  https://www.edx.org/learn/data-analysis/harvard-university-causal-diagrams-draw-your-assumptions-before-your-conclusions target='_blank'> Draw your assumptions before your conclusions’ </a> avec Miguel Hernán sur edX
             <br> Livre (version bookdown disponible) : <a href = https://www.theeffectbook.net/ch-CausalDiagrams.html target = '_blank'> The Effect: An Introduction to research Design and Causality </a> de Nick Huntington-Klein
           <br> Site internet et package R pour dessiner un DAG : <a href = https://dagitty.net target='_blank'> dagitty.net </a>  
           <br> 
           <br>
           <b> Introduction à l'inférence causale : </b>
           <br> Livres :  <a href = https://www.hsph.harvard.edu/miguel-hernan/causal-inference-book/ target='_blank'> Hernán MA, Robins JM (2020). <i> Causal Inference: What If.</i> Boca Raton: Chapman & Hall/CRC.</a>
           <br> Vidéo YouTube : <a href = https://www.youtube.com/watch?v=SbrX3YEMj_0 target = '_blank'> Causal Inference Seminar : Peter Tennant </a> sur la chaîne Oxford Population Health
           <br> Article scientifique : <a href = https://link.springer.com/article/10.1007/s40471-022-00288-7 target = '_blank'> Matthay, E. C., & Glymour, M. M. (2022). <i>Causal inference challenges and new directions for epidemiologic research on the health effects of social policies. Current Epidemiology Reports,</i> 9(1), 22-37. </a>
           <br> Article scientifique : <a href = https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4077670/ target = '_blank'> Petersen, M. L., & van der Laan, M. J. (2014). <i>Causal models and learning from data: integrating causal modeling and statistical estimation. Epidemiology (Cambridge, Mass.),</i> 25(3), 418. </a>
           <br>
           <br> <b> Introduction à l'analyse de médiation : </b>
           <br> Article scientifique : <a href = https://pubmed.ncbi.nlm.nih.gov/26653405/ target='_blank'> VanderWeele, T. J. (2016). <i> Mediation analysis: a practitioner's guide. Annual review of public health, </i> 37, 17-32.</a>
           <br> Livre : VanderWeele, T. (2015). <i>Explanation in causal inference: methods for mediation and interaction.</i> Oxford University Press.
           <br> Workshop présentation des méthodes avec exemples de code R (en cours de développement) : <a href = https://benoitlepage.github.io/mediation_workshop/ target = '_blank'> Mediaton Workshop </a> de Benoît Lepage
           <br> Site internet : <a href = https://www.hsph.harvard.edu/tyler-vanderweele/tools-and-tutorials/ target='_blank'> Tyler VanderWeele's website </a> qui contient des outils, tutoriels et vidéos
           <br>
           <br>
           <b> G-méthodes :</b> 
           <br> Article scientifique : <a href = https://academic.oup.com/ije/article/46/2/756/2760169?login=true target='_blank'> Naimi, A. I., Cole, S. R., & Kennedy, E. H. (2017). <i>An introduction to g methods. International journal of epidemiology,</i> 46(2), 756-762.</a>
           <br> Article scientifique : <a href = https://onlinelibrary.wiley.com/doi/10.1002/sim.5686 target = '_blank'> Daniel, R. M., Cousens, S. N., De Stavola, B. L., Kenward, M. G., & Sterne, J. A. C. (2013). <i>Methods for dealing with time‐dependent confounding. Statistics in medicine,</i> 32(9), 1584-1618.</a>
           <br> Article scientifique sur les MSM : <a href = https://pubmed.ncbi.nlm.nih.gov/10955408/ target = '_blank'> Robins, J. M., Hernan, M. A., & Brumback, B. (2000). <i> Marginal structural models and causal inference in epidemiology. Epidemiology,</i> 550-560. </a>
           <br> Article scientifique sur les MSM pour la médiation : <a href = https://pubmed.ncbi.nlm.nih.gov/19234398/ target = '_blank'> VanderWeele, T. J. (2009). <i>Marginal structural models for the estimation of direct and indirect effects. Epidemiology,</i> 18-26.</a>
           <br> Article scientifique sur la g-computation : <a href = https://pubmed.ncbi.nlm.nih.gov/35391523/ target = '_blank'> Lee, S., & Lee, W. (2022). <i>Application of Standardization for Causal Inference in Observational Studies: A Step-by-step Tutorial for Analysis Using R Software. Journal of Preventive Medicine and Public Health, </i> 55(2), 116.</a>
           <br> Article scientifique sur l'implémentation de la g-computation : <a href = https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3105284/ target='_blank'> Snowden, J. M., Rose, S., & Mortimer, K. M. (2011). <i>Implementation of G-computation on a simulated data set: demonstration of a causal inference technique. American journal of epidemiology,</i> 173(7), 731-738.</a>
           <br> Article scientifique sur la g-compuation pour la médiation : <a href = https://pubmed.ncbi.nlm.nih.gov/27984420/ target = '_blank'> Lin, S. H., Young, J., Logan, R., Tchetgen, E. J. T., & VanderWeele, T. J. (2017). <i>Parametric mediational g-formula approach to mediation analysis with time-varying exposures, mediators, and confounders. Epidemiology (Cambridge, Mass.),</i> 28(2), 266.</a>
           <br>
           <br>
           <b> Scores de propension : </b>
           <br>Tutoriel R pour l'IPW : <a href = https://www.andrewheiss.com/blog/2020/12/01/ipw-binary-continuous/ target = '_blank'> Heiss, Andrew. 2020. “Generating Inverse Probability Weights for Both Binary and Continuous Treatments.” December 1, 2020. https://doi.org/10.59350/1svkc-rkv91.</a>
           <br>Tutoriel R pour le matching : <a href = https://simonejdemyr.com/r-tutorials/statistics/tutorial8.html target = '_blank'> R Tutorial 8: Propensity Score Matching </a> de Simon Ejdemyr
           <br>Article scientifique sur l'IPW pour la médiation : <a href = https://onlinelibrary.wiley.com/doi/full/10.1002/jae.2341 target = '_blank'> Huber, M. (2014). <i>Identifying causal mechanisms (primarily) based on inverse probability weighting. Journal of Applied Econometrics, </i> 29(6), 920-943.</a>
           <br>
           <br>
           <b> Natural effect models : </b>
           <br> Article scientifique : <a href = https://academic.oup.com/aje/article/176/3/190/99496?login=true target = '_blank'> Lange, T., Vansteelandt, S., & Bekaert, M. (2012). <i>A simple unified approach for estimating natural direct and indirect effects. American journal of epidemiology,</i> 176(3), 190-195.</a>
           <br>Article scientifique : <a href = https://www.degruyter.com/document/doi/10.1515/2161-962X.1014/html target = '_blank'> Vansteelandt, S., Bekaert, M., & Lange, T. (2012). <i>Imputation strategies for the estimation of natural direct and indirect effects. Epidemiologic Methods,</i> 1(1), 131-158.</a>
           <br>Article scientifique : <a href = https://academic.oup.com/aje/article/189/11/1427/5847587 target='_blank'> Mittinty, M. N., & Vansteelandt, S. (2020). <i>Longitudinal mediation analysis using natural effect models. American Journal of Epidemiology,</i> 189(11), 1427-1435.</a>
           <br>
           <br>
           <b> Targeted Maximum Likelihood Estimation : </b>
           <br> Article scientifique : <a href = https://academic.oup.com/aje/article/185/1/65/2662306 target='_blank'> Schuler, M. S., & Rose, S. (2017). <i>Targeted maximum likelihood estimation for causal inference in observational studies. American journal of epidemiology,</i> 185(1), 65-73.</a>
           <br> Article scientifique TMLE pour les effets naturels directs : <a href = https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6055937/ target = '_blank'> Zheng, W., & van der Laan, M. J. (2012). <i>Targeted maximum likelihood estimation of natural direct effects. The international journal of biostatistics,</i> 8(1), 1-40.</a>
           <br>
           <br>
           <b> Analyse de sensibilité : </b>
           <br>Article scientifique : <a href = https://dash.harvard.edu/handle/1/36874927 target = '_blank'> VanderWeele, T. J., & Ding, P. (2017). <i>Sensitivity analysis in observational research: introducing the E-value. Annals of internal medicine,</i> 167(4), 268-274.</a>
           <br>Article scientifique : <a href = https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6768718/ target = '_blank'> Smith, L. H., & VanderWeele, T. J. (2019). <i>Mediational E-values: approximate sensitivity analysis for unmeasured mediator–outcome confounding. Epidemiology (Cambridge, Mass.),</i> 30(6), 835.</a>
           <br>
          <br>"),
         )
)