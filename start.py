import spacy
from transformers import pipeline

nlp = spacy.load("en_core_web_sm")
generator = pipeline("text-generation", model="EleutherAI/gpt-neo-2.7B")

input_text = "Bob is Player 1. Bob's move was rock. Alice is Player 2. Alice's move was scissors."

# Load rules as list
# with open("tests/prolog/rps.pl") as rl:
#     prolog_rules = [r.strip() for r in rl]
# print(prolog_rules)


# preprocess natural language text
def preprocess(text):
    doc = nlp(text)
    entities = [ent.text for ent in doc.ents]
    return entities

# generate Prolog facts
def generate_facts(entities):
    facts = []
    for entity1 in entities:
        for entity2 in entities:
            if entity1 != entity2:
                facts.append(f"father({entity1}, {entity2}).")
                fact.append(f"mother({entity1}, {entity2}).")
    return fact

# rank Prolog facts using the LLM
def rank_fact(fact, text):
    ranked_facts = []
    for fact in fact:
        input_text = f"{text} {fact}"
        generated_text = generator(input_text, max_length=100, do_sample=True, temperature=0.7)[0]["generated_text"]
        rank_score = nlp(generated_text).similarity(nlp(fact))
        ranked_facts.append((fact, rank_score))
    ranked_facts.sort(key=lambda x: x[1], reverse=True)
    return ranked_facts

# select top-ranked facts and validate them
def select_top_facts(ranked_facts, threshold=0.8):
    selected_facts = []
    for fact, rank_score in ranked_facts:
        if rank_score >= threshold:
            selected_facts.append(fact)
    return selected_facts

def derive_prolog_facts(text, prolog_rules_file):
    with open(prolog_rules_file, "r") as f:
        prolog_rules = f.read()

    entities = preprocess(text)
    fact = generate_fact(entities)
    ranked_facts = rank_fact(fact, text)
    selected_facts = select_top_facts(ranked_facts)

    return selected_facts

if __name__ == "__main__":
    prolog_facts = derive_prolog_facts(input_text, "tests/prolog/rps.pl")
    print("Derived Prolog Facts:")
    for fact in prolog_facts:
        print(fact)