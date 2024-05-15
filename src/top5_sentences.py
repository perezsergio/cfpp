from nltk.tokenize import sent_tokenize
from sys import argv
from spacy_universal_sentence_encoder import (
    load_model as load_universal_sentence_encoder,
)
from spacy.lang.en import English
import warnings


def get_top5(search_string: str, sentences: list[str], nlp: English):
    # top 5 sentences with higher similarity will be stored in a dictionary with the format
    # {similarity: sentence}
    top_5 = {0: ""}
    for sentence in sentences:
        # Compute similarity using nlp
        similarity = nlp(sentence).similarity(nlp(search_string))
        # If similarity is not big enough to enter in the top 5, continue to next sentence
        if similarity < min(top_5.keys()):
            continue
        # Else, add current similarity, sentence to the top_5 dict
        top_5[similarity] = sentence
        # If the top_5 dict has more than 5 elements, delete the one with the smallest similarity
        if len(top_5.keys()) > 5:
            del top_5[min(top_5.keys())]
    # Return array with top 5 sentences, ordered from largest similarity
    return [top_5[sim] for sim in sorted(top_5.keys(), reverse=True)]


def main():
    # Suppress all warnings
    warnings.filterwarnings("ignore")
    # Assert num of cli arguments is 2 (3 including file itself)
    assert len(argv) == 3, f"Usage: python3 {argv[0]} 'text' 'search_string' "
    # Parse cli arguments
    text: str = argv[1]
    search_string: str = argv[2]
    # Divide text into sentences using nltk.tokenize.sent_tokenize
    sentences: list[str] = sent_tokenize(text)
    # load google universal sentence encoder
    nlp = load_universal_sentence_encoder("en_use_lg")
    # Compute top5 sentences with the most similarity
    top_5 = get_top5(search_string, sentences, nlp)
    # print top 5 sentences
    results = ""
    for sentence in top_5:
        results += "|" + sentence.replace("\n", " ")
    print(results)


if __name__ == "__main__":
    main()
