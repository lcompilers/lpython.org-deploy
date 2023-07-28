import requests

def get_total_stars(name):
    # Caution: This works for only 1 loop iteration,
    # after that GitHub doesn't respond for a while
    url = f"https://api.github.com/repos/{name}"
    response = requests.get(url)

    if response.status_code == 200:
        repo_data = response.json()
        total_stars = repo_data['stargazers_count']
        return total_stars
    else:
        print(f"Error {response.status_code}: "
              f"Unable to fetch data for repository {name}")
        return None

# Data as on 2023-07-28
#  Recent commits example
# https://github.com/cupy/cupy?from=2022-07-28&to=2023-07-28&type=c

compilers_list = {
    # Name : [Total Contributors, Recent Contributors, Total stars]
    "pytorch/pytorch"           : [2857, 75, 69253], # 15 < 10 commits
    "pyston/pyston"             : [1263,  2,  2426],
    "google/jax"                : [ 523, 60, 24010],  # 37  < 10 commits
    "cython/cython"             : [ 435, 18,  8168],
    "numba/numba"               : [ 306, 25,  8790],
    "cupy/cupy"                 : [ 286, 15,  7062],
    "taichi-dev/taichi"         : [ 224, 44, 23503],
    "Nuitka/Nuitka"             : [ 138, 36,  9385], # Except 1, all others < 10 commits,
                                                     # (Most of them (27) are 1 commit)
    "serge-sans-paille/pythran" : [  58,  9,  1912],
    "pypy/pypy.org"             : [  36,  5,    21], # Website
    "weld-project/weld"         : [  35,  0,  2945],
    "lcompilers/lpython"        : [  34, 28,   141],
    "IronLanguages/ironpython3" : [  33,  5,  2179],
    "pyccel/pyccel"             : [  32, 17,   279], # 15 < 10 commits
    "pyjs/pyjs"                 : [  30,  0,  1123],
    "google/grumpy"             : [  29,  0, 10580], # Archived on Mar 23, 2023
    "Quansight-Labs/uarray"     : [  22,  1,    98],
    "shedskin/shedskin"         : [  20,  7,   701],
    "jython/jython"             : [  18,  4,   897],
    "seq-lang/seq"              : [   9,  0,   680], # Archived on Dec 8, 2022.
    "jakeret/hope"              : [   6,  0,   385],
    "fluiddyn/transonic"        : [   3,  1,   105],
}

# To update GitHub stars
# Caution: `get_total_stars`` works only on,
# after that GitHub doesn't respond for a while.
# Error: API rate limit exceeded for "ip_address"
# Solution: change your IP (network)
# for i in compilers_list:
#     compilers_list[i][2] = get_total_stars(i)
#     print("https://github.com/" + i)

# pprint(compilers_list)
