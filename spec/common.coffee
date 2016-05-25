((global) ->
  global.Spec ||= {}

  global.Spec.stringifyAndSort = (arr) ->
    result = []

    for val in arr
      result.push(val.join(':'))

    return result.sort()

  global.Spec.equalArrays = (arr1, arr2) ->
    return true if (arr1 == arr2)
    return false if (arr1 == null || arr2 == null)
    arr1.sort()
    arr2.sort()

    for e, k in arr1
      return false if e != arr2[k]

    return true

  global.Spec.equalArrays2Dim = (arr1, arr2) ->
    return true if (arr1 == arr2)
    return false if (arr1 == null || arr2 == null)
    return false if (arr1.length != arr2.length)

    normalizedArr1 = Spec.stringifyAndSort(arr1)
    normalizedArr2 = Spec.stringifyAndSort(arr2)

    for v, k in normalizedArr1
      return false if v != normalizedArr2[k]

    return true
)(window)
