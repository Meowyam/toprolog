covered(C, N) :- 
    claim_policy(C, P), 
    policy_in_effect(P), 
    claim_hospitalization(C, H), 
    hospitalization_conditions_met(H), 
    benefit_calc(C, N), 
    \+ exclusion_applies(C).

policy_in_effect(P) :- 
    policy_signed(P), 
    policy_paid_premium(P), 
    condition_met_1_3(P), 
    \+ policy_canceled(P).

condition_met_1_3(P) :- policy_wellness_visit_confirmation_provided(P).

policy_paid_premium(P) :- 
    policy_premium_amount_paid(P, A), 
    geq(A, 2000).

hospitalization_conditions_met(H) :- hospitalization_valid_reason(H), hospitalization_country(H, usa).

hospitalization_valid_reason(H) :- hospitalization_reason(H, sickness).
hospitalization_valid_reason(H) :- hospitalization_reason(H, accidental_injury).

exclusion_applies(C) :- 
    claim_hospitalization(C, H), 
    (hospitalization_causal_event(H, skydiving);
    hospitalization_causal_event(H, military_service);
    hospitalization_causal_event(H, firefighting_service);
    hospitalization_causal_event(H, police_service);
    (hospitalization_patient(H, X), person_age(X, A), geq(A, 75))).

benefit_calc(C, N) :- 
    claim_hospitalization(C, H), 
    duration_days(H, D), 
    evaluate(max(0, times(D, 500)), N).

duration_days(H, D) :- 
    duration(H, D_MS), 
    evaluate(floor(quotient(D_MS, 86400000)), D).

duration(Z, DURATION) :-
    hospitalization_startdate(Z, SD),
    hospitalization_starttime(Z, ST),
    hospitalization_enddate(Z, ED),
    hospitalization_endtime(Z, ET),
    datetimetotimestamp(SD, ST, SS),
    datetimetotimestamp(ED, ET, ES),
    evaluate(minus(ES, SS), DURATION).

geq(X, Y) :- evaluate(min(X, Y), Y).

% Placeholder predicates to be defined
claim_policy(_, _).
claim_hospitalization(_, _).
policy_signed(_).
policy_canceled(_).
policy_wellness_visit_confirmation_provided(_).
policy_premium_amount_paid(_, _).
hospitalization_country(_, _).
hospitalization_reason(_, _).
hospitalization_causal_event(_, _).
hospitalization_patient(_, _).
person_age(_, _).
evaluate(_, _).
datetimetotimestamp(_, _, _).
hospitalization_startdate(_, _).
hospitalization_starttime(_, _).
hospitalization_enddate(_, _).
hospitalization_endtime(_, _).

