((global) ->
  global.Spec ||= {}

  global.Spec.sort = (array) ->
    return array if array.length < 1

    length = array[0].length

    for i in [0..length]
      array.sort((a, b) ->
        return 1 if a[i] > b[i]
        return -1 if a[i] < b[i]
        return 0 if a[i] = b[i]
      )

    array

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

    arr1 = Spec.sort(arr1)
    arr2 = Spec.sort(arr2)

    for e, k in arr1
      return false if e[0] != arr2[k][0] || e[1] != arr2[k][1]

    return true
)(window)
