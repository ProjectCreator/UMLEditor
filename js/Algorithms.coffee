# NOTE: from https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#JavaScript
# App.Algorithms.levenshteinDistance = (s, t) ->
#     if s.length is 0
#         return t.length
#     if t.length is 0
#         return s.length
#
#     subS = s.substring(1)
#     subT = t.substring(1)
#
#     return Math.min(
#         levenshteinDistance(subS, t) + 1
#         levenshteinDistance(subT, s) + 1
#         levenshteinDistance(subS, subT) + (if s[0] isnt t[0] then 1 else 0)
#     )

App.Algorithms.levenshteinDistance = (a, b) ->
    aLength = a.length
    bLength = b.length
    if aLength is 0
        return bLength
    if bLength is 0
        return aLength

    matrix = []

    # increment along the first column of each row
    for i in [0..bLength]
        matrix[i] = [i]

    # increment each column in the first row
    for j in [0..aLength]
        matrix[0][j] = j

    # Fill in the rest of the matrix
    for i in [1..bLength]
        for j in [1..aLength]
            if b.charAt(i - 1) is a.charAt(j - 1)
                matrix[i][j] = matrix[i - 1][j - 1]
            else
                matrix[i][j] = Math.min(
                    # substitution
                    matrix[i - 1][j - 1] + 1
                    Math.min(
                        # insertion
                        matrix[i][j - 1] + 1
                        # deletion
                        matrix[i - 1][j] + 1
                    )
                )

    return matrix[bLength][aLength]

App.Algorithms.levDist = App.Algorithms.levenshteinDistance
