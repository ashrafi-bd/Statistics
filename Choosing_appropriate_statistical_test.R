library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

g <-grViz("
digraph combined_stats_tree {

  graph [
    rankdir = TB
    nodesep = 0.45
    ranksep = 0.6
    fontname = Helvetica
    splines = ortho
    pad = 0.3
  ]

  node [
    shape = rectangle
    style = filled
    fillcolor = \"#DDF3F8\"
    color = black
    fontname = Helvetica
    fontsize = 11
    penwidth = 1
    margin = 0.08
  ]

  // Root
  H    [label = \"What is the hypothesis?\", fillcolor = \"#4CB4CE\", fontsize = 12, penwidth = 1.2]

  // First branch
  RelDiff   [label = \"Relationship between variables\", fillcolor = \"#FFFFCC\"]
  DiffVars  [label = \"Difference between variables\",   fillcolor = \"#FFFFCC\"]

  H -> RelDiff
  H -> DiffVars

  // ========= RELATIONSHIP (FIGURE 11-2 CONTENT) =========

  // Parametric vs Nonparametric for relationship
  RelParam  [label = \"Parametric\", fillcolor = \"#B6E4EF\"]
  RelNonpar [label = \"Nonparametric\", fillcolor = \"#B6E4EF\"]

  RelDiff -> RelParam
  RelDiff -> RelNonpar

  // Parametric side: Correlation & Regression
  Corr      [label = \"Correlation (association)\"]
  Regr      [label = \"Regression (prediction)\"]
  RelParam -> Corr
  RelParam -> Regr

  Pearson   [label = \"Pearson r\"]
  Corr -> Pearson

  SimpleR   [label = \"Simple\"]
  MultipleR [label = \"Multiple\"]
  Regr -> SimpleR
  Regr -> MultipleR

  // Nonparametric relationship
  Spearman  [label = \"Spearman r\"]
  RelNonpar -> Spearman

  // ========= DIFFERENCE (FIGURE 11-3 CONTENT) =========

  // Parametric vs Nonparametric for difference
  DiffNonpar [label = \"Nonparametric\", fillcolor = \"#B6E4EF\"]
  DiffParam  [label = \"Parametric\", fillcolor = \"#B6E4EF\"]
  DiffVars -> DiffNonpar
  DiffVars -> DiffParam

  // Nonparametric difference: Independent only shown in figure
  NP_Ind    [label = \"Independent\"]
  DiffNonpar -> NP_Ind

  NP2       [label = \"2 levels\"]
  NPgt2     [label = \">2 levels\"]
  NP_Ind -> NP2
  NP_Ind -> NPgt2

  MWU       [label = \"Mann-Whitney U\\nWilcoxon rank sum\"]
  KW        [label = \"Kruskal-Wallis\"]
  NP2   -> MWU
  NPgt2 -> KW

  // Parametric difference: Independent vs Related
  P_Ind     [label = \"Independent\"]
  P_Rel     [label = \"Related\"]
  DiffParam -> P_Ind
  DiffParam -> P_Rel

  // Independent parametric
  P2        [label = \"2 levels\"]
  Pgt2      [label = \">2 levels\"]
  P_Ind -> P2
  P_Ind -> Pgt2

  Ttest     [label = \"t-test\"]
  ANOVA1    [label = \"ANOVA\"]
  P2   -> Ttest
  Pgt2 -> ANOVA1

  // Factorial & Multivariate ANOVA extension
  FactorCond [label = \"2 or more variables +\\n2 or more levels\"]
  ANOVA1 -> FactorCond
  Factorial  [label = \"Factorial ANOVA\"]
  MANOVA1    [label = \"Multivariate ANOVA\"]
  FactorCond -> Factorial
  FactorCond -> MANOVA1

  // Related parametric
  R2        [label = \"2 levels\"]
  Rgt2      [label = \">2 levels\"]
  P_Rel -> R2
  P_Rel -> Rgt2

  PairedT   [label = \"Paired t\"]
  RMANOVA   [label = \"Repeated measures\\nANOVA\"]
  R2   -> PairedT
  Rgt2 -> RMANOVA

  MANOVA2   [label = \"Multivariate ANOVA\"]
  RMANOVA -> MANOVA2

  // ====== Aesthetics tweaks (optional ranks) ======
  {rank = same; RelDiff; DiffVars}
  {rank = same; RelParam; RelNonpar; DiffNonpar; DiffParam}
  {rank = same; Corr; Regr; NP_Ind; P_Ind; P_Rel}
}
")

svg_txt <- export_svg(g)

charToRaw(svg_txt) |>
  rsvg_png(file = "Appropriate_Stat_Test.png", width = 1800, height = 1400)

