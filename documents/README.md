# NEDOCS

## Clinical Goal:
create a model that predict whether the NEDOCS score will go into orange or higher in 1-4 hours ahead of current time.

## Background:
The National Emergency Department Overcrowding Study (NEDOCS) is an empirically-developed scoring model to assess the current level of Emergency Department (ED) crowding (Weiss et al. 2004), and has been used in the Seattle Children's ED since 2011. The score is calculated about every 15 minutes from a set of variables considered to be closely related to overcrowded ED conditions (see Table 1). The formula (Figure 1) produces a score on a scale of 0-200, though in practice the actual value is irrelevant; instead, an ordinal scale of green (0-60), yellow (61-100), orange (101-130), red (131-180), and black (181-200) is used to provide an at-a-glance sense of current and recent ED crowding (Figure 2). When values get into the orange, the ED often needs to call in additional resources. Going into red triggers the ED Surge Process in which charge nurses have specific tasks meant to reduce overcrowding, including bringing in additional resources. Being able to predict when orange or higher might occur allows ED staff to pre-plan the need for additional resources so that they can be available and ready when crowding reaches higher levels. Having at least an hour warning (two hours is even better) allows ED administration to begin the process of calling in additional resources. In early 2018, an initial forecast model (using random forest classification) was implemented for trial use in the ED (Figure 2), and that trial is currently live and ongoing. The initial model suffers from a few flaws and definitely can be improved. 

## Strategy: 
- Use EDA of NEDOCS and NEDOCS variables to explore what temporal and/or statistical patterns may exist.
- Use NEDOCS variables (and derivations from existing fields, e.g., Month, Day of Week, holiday, etc.) to create models to predict NEDOCS color group between 1 and 4 hours ahead of current time. If project time is limiting, focus on 2 hours ahead, and then explore other forecast lead times if deadlines/other priorities allow. Explore whether time series modeling or machine learning approaches do better. Multi-model approaches like Super Learners may be useful. 
- A major flaw of the current model is it was created by sampling randomly across the time period of interest to generate training and test sets. A more defensible approach is to use a time segmented method for training and testing (e.g., time slicing/time series cross-validation/rolling forecast origin).
- Determine if other variables either intrinsic to the data (e.g., Fourier transform of time series, lags, slopes, acceleration) or extrinsic to the data (e.g., weather, air quality, sporting events, etc.) can improve the forecast.
- Determine whether forecasting the NEDOCS score and then translating that to a color group or forecasting the color group directly is a better approach. (It probably is.)
- “Alarm fatigue” is a real problem in hospitals, but we also don’t want to miss too many true positives. Thus, some sort of trade-off between precision and recall will need to be made. 
- Validate and tune model with help of ED clinicians/managers and SCEA data scientists. Ideally, the model will be self-correcting over time, since ED staffing levels change over time, something not currently reflected in the NEDOCS score or variables. This is much trickier to do, so we expect for the near term, a manual retraining will need to occur at a reasonable time step. Determining that time step would be a useful outcome, if possible (monthly? bimonthly? quarterly?).
- Programmatically add model outputs to original input data and export as csv and/or json. 
- Document workflow process and model results for both data scientists (technical) and lay (ED clinician) audiences. Provide suggestions for improvement of materials (model summary report) for each audience. 
Outcome Products: 
- Summary report of major EDA findings. Rmarkdown and/or Jupyter notebook format preferred. 
- Predictive models created, tested, and tuned. A stand-alone R or Python model preferred for final model. R or Python code for model creation, testing, and tuning preferred (Rmarkdown and/or Jupyter notebooks can be the delivery format.)
- Model outputs added back to data and sent to reporting platform/alerting system. Stand-alone model code includes all ELT into and out of the model. 
- Workflow/process and model results documented. 

## Table 1. Data fields in nedocs_dataset.csv (input-data-file) 
| Column Name | Data Type | Nullable? | Data Default | Column ID | Primary Key | Comments |
| ----------- | --------- | --------- | ------------ | --------- | ----------- | -------- |
| ACTIVE_IND | NUMBER | No | 1 | 1 | | Active indicator | 
| SCORE_ID | NUMBER | No | 0 | 2 | 1 | Nedocs score identifier | 
| SCORE | NUMBER | No | 0 | 3 | | Nedocs score | 
| SCORE_DT_TM | DATE | No | SYSDATE | 4 | | | 
| TOTAL_ED_PATS | NUMBER | Yes | | 5 | | ED occupancy | 
| ED_PODS | NUMBER | Yes | | 6 | | Number ED pods open | 
| ED_BEDS | NUMBER | Yes | | 7 | | Number ED beds in service | 
| HOSP_BEDS | NUMBER | Yes | | 8 | | Number licensed hospital beds | 
| ADMIT_PATS | NUMBER | Yes | | 9 | | Number patients awaiting admit | 
| HIGH_ACUITY_PATS | NUMBER | Yes | | 10 | | Number high acuity patients | 
| LONGEST_ADMIT_LOS | NUMBER | Yes | | 11 | | Longest LOS awaiting admit | 
| LONGEST_WAIT | NUMBER | Yes | | 12 | | Longest wait in lobby | 
| UPDT_DT_TM | DATE | No | SYSDATE | 13 | | 
| UPDT_ID | NUMBER | Yes |  | 14 | | Update personnel id  | 

## Table 2. Data fields from model output (output-data-file)
| Variable | Meaning |
| -------- | ------- |
| SCORE_ID | Nedocs score identifier | 
| SCORE_DT_TM | Nedocs score generation timestamp | 
| SCORE | NEDOCS score at t = 0 |
| TOTAL_ED_PATS| Number of patients being seen in ED at t = 0 |
| ED_PODS| Number of ED pods open at t = 0, rough approximation to resource scheduling, last updated in 2013 |
| ED_BEDS| Number of ED beds open at t = 0, rough approximation to resource scheduling, last updated in 2013 |
| HOSP_BEDS | Number licensed hospital beds | 
| ADMIT_PATS| Number of patients awaiting admit to inpatient at t = 0 |
| HIGH_ACUITY_PATS | Number of patients in ED at acuity levels ESI 1 or 2 at t = 0 |
| LONGEST_ADMIT_LOS| Total minutes wait time for longest current ED patient awaiting admit to inpatient at t = 0 |
| LONGEST_WAIT | Total minutes wait time for longest current individual in lobby at t = 0 |
| PROBABILITY_COLOR_2_HOURS | The probability of Nedocs score will be in a specific color bucket |
| PREDICTED_COLOR_2_HOURS | IF PROBABILITY_COLOR_2_HOURS >= 0.75<br>Then "Orange/Red"<br> Else "Green/Yellow" |