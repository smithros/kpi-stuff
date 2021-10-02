import math

############################################################
# Problem 1a

def findAlphabeticallyLastWord(text):
    """
    Given a string |text|, return the word in |text| that comes last
    alphabetically (that is, the word that would appear last in a dictionary).
    A word is defined by a maximal sequence of characters without whitespaces.
    You might find max() and list comprehensions handy here.
    """
    # BEGIN_YOUR_CODE (our solution is 1 line of code, but don't worry if you deviate from this)
    return max([el for el in text.split()])
    # END_YOUR_CODE

############################################################
# Problem 1b

def euclideanDistance(loc1, loc2):
    """
    Return the Euclidean distance between two locations, where the locations
    are pairs of numbers (e.g., (3, 5)).
    """
    # BEGIN_YOUR_CODE (our solution is 1 line of code, but don't worry if you deviate from this)
    # https://en.wikipedia.org/wiki/Euclidean_distance
    return math.sqrt(math.fsum([math.pow((l1 - l2), 2) for l1, l2 in zip(loc1, loc2)]))
    # END_YOUR_CODE

############################################################
# Problem 1c

def sparseVectorDotProduct(v1, v2):
    """
    Given two sparse vectors |v1| and |v2|, each represented as collections.defaultdict(float), return
    their dot product.
    You might find it useful to use sum() and a list comprehension.
    This function will be useful later for linear classifiers.
    """
    # BEGIN_YOUR_CODE (our solution is 4 lines of code, but don't worry if you deviate from this)
    result = 0
    for k1, val1 in v1.items():
        for k2, val2 in v2.items():
            if k1 == k2:
                result += val1*val2
    return result
    # END_YOUR_CODE

############################################################
# Problem 3e

def incrementSparseVector(v1, scale, v2):
    """
    Given two sparse vectors |v1| and |v2|, perform v1 += scale * v2.
    This function will be useful later for linear classifiers.
    """
    # BEGIN_YOUR_CODE (our solution is 2 lines of code, but don't worry if you deviate from this)
    for k, val in v2.items():
        v2[k] *= scale
    v_tmp = v1.copy()
    for k in v1.keys():
        for k2 in v2.keys():
            if k == k2:
                v_tmp[k] += v2[k2]
            else:
                v_tmp[k2] = v2[k2]
    return v_tmp
    # END_YOUR_CODE


def findSingletonWords(text):
    """
    Splits the string |text| by whitespace and returns the set of words that
    occur exactly once.
    You might find it useful to use collections.defaultdict(int).
    """
    # BEGIN_YOUR_CODE (our solution is 4 lines of code, but don't worry if you deviate from this)
    words = text.lower().split()
    return set(word for word in words if words.count(word) == 1)
    # END_YOUR_CODE
