// Алгоритм, который используется для определения количественного критерия в отличии двух слов
// Алгоритм не моя разработка, использую в приложении
// Пример: levenstain(text_1: "молоко", text_2: "малако") = 2

func levenstain(text_1: String, text_2: String) -> Double {
 
  if text_1.count == 0 || text_2.count == 0 {
    return MAXCOUNTWORDERROR
  } else if abs(text_1.count - text_2.count) >= Int(MAXCOUNTWORDERROR) {
    return MAXCOUNTWORDERROR
  } else {
    let (t, s) = (text_1, text_2)
    let empty = Array<Int>(repeating:0, count: s.count)
    var last = [Int](0...s.count)
    for (i, tLett) in t.enumerated() {
      var cur = [i + 1] + empty
      for (j, sLett) in s.enumerated() {
        cur[j + 1] = tLett == sLett ? last[j] : min(last[j], last[j + 1], cur[j])+1
      }
      last = cur
     }
    return Double (last.last!)        
  }
  
}

// Также в приложении используется расширенная версия алгоритма Левенштейна.
// Наименование продукта, например, "Соевое молоко", часто состоит из нескольких слов. 
// И при работе приложения нужно количественно определять различие между "Соевым молоком" и "Молоком". 
// Таким образом приложение разделяет сравниваемые слова на три типа:
// 1) Одинаковые слова (ошибка между 0 ... 0.01). 
// 2) Похожие слова (ошибка между 0.02 ... 3.99). 
// 3) Разные слова (ошибка больше 4). 

// Работа метода не является мгновенной, а занимает некоторое время. 
// По этой причине этот метод работает в отдельном потоке и не влияет на скорость работы приложения.

func levenstainSecondLevel(str_1: String, str_2: String, limit: Bool) -> Double {
        
  // Пустые продукты возвращают максимальную ошибку
  // Максимальная ошибка означает, что приложение уже не рассматривает слова как похожие
  
        if str_1 == "" || str_2 == "" {
            if !limit {
                return MAXCOUNTWORDERROR_NO_LIMIT // = 50
            } else {
                return MAXCOUNTWORDERROR // = 4
            }
        }
        
  // Слова разделяются массивы. Разделителем служат пробелы между слов.
  // Это необходимо, чтобы продукты "Соевое молоко" и "Молоко соевое" считались одинаковыми словами.
  
        var massiveStr1: [Substring] = []
        var massiveStr2: [Substring] = []
        
        if str_1.split(separator: " ").count < str_2.split(separator: " ").count {
            massiveStr1 = str_1.split(separator: " ")
            massiveStr2 = str_2.split(separator: " ")
        } else {
            massiveStr2 = str_1.split(separator: " ")
            massiveStr1 = str_2.split(separator: " ")
        }
        
        var enableSmallError: Bool
        var dLevenstain = [[Double]]()
        var dLevenstainHelper = [[Double]]()
        
        dLevenstain = Array(repeating: Array(repeating: 0, count: massiveStr2.count), count: massiveStr1.count)
        
        if massiveStr1.count < 1 || massiveStr2.count < 1 {
            if !limit {
                return MAXCOUNTWORDERROR_NO_LIMIT
            } else {
                return MAXCOUNTWORDERROR
            }
        }
        for i in 0...massiveStr1.count - 1 {
            enableSmallError = false
            for j in 0...massiveStr2.count - 1 {
                dLevenstain[i][j] = levenstain(text_1: String(massiveStr1[i]), text_2: String(massiveStr2[j]))
                if !limit {
                    if dLevenstain[i][j] < MAXCOUNTWORDERROR_NO_LIMIT && !enableSmallError {
                        enableSmallError = true
                    }
                } else {
                    if dLevenstain[i][j] < MAXCOUNTWORDERROR && !enableSmallError {
                        enableSmallError = true
                    
                }
            }
            if !enableSmallError {
                if !limit {
                    return MAXCOUNTWORDERROR_NO_LIMIT
                } else {
                    return MAXCOUNTWORDERROR
                }
            }
        }
        
        var countAccessErrorInTheLine: Int
        var currentCountAccessErrorInTheLine: Int
        var currentCountErrorInTheColumn: Double
        var numberLineWithMinimumError: Int
        var numberColumnWithMinimumError: Int
        var differentWord: Double = 0
        var kError: Double = 0
        
        currentCountAccessErrorInTheLine = dLevenstain.count + 2
                    numberLineWithMinimumError = 0
                    for i in 0...dLevenstain.count - 1 {
                        countAccessErrorInTheLine = 0
                        for j in 0...dLevenstain[0].count - 1 {
                            if !limit {
                                if dLevenstain[i][j] < MAXCOUNTWORDERROR_NO_LIMIT {
                                    countAccessErrorInTheLine += 1
                                }
                            } else {
                                if dLevenstain[i][j] < MAXCOUNTWORDERROR {
                                    countAccessErrorInTheLine += 1
                                }
                            }
                            
                        }
                        if countAccessErrorInTheLine < currentCountAccessErrorInTheLine {
                            currentCountAccessErrorInTheLine = countAccessErrorInTheLine
                            numberLineWithMinimumError = i
                        }
                    }
                    
        if !limit {
            currentCountErrorInTheColumn = MAXCOUNTWORDERROR_NO_LIMIT
        } else {
            currentCountErrorInTheColumn = MAXCOUNTWORDERROR
        }
                    
        numberColumnWithMinimumError = 0
                    
        for j in 0...dLevenstain[0].count - 1 {
            if dLevenstain[numberLineWithMinimumError][j] < currentCountErrorInTheColumn {
                currentCountErrorInTheColumn = dLevenstain[numberLineWithMinimumError][j]
                numberColumnWithMinimumError = j
            }
        }
                    
        kError += dLevenstain[numberLineWithMinimumError][numberColumnWithMinimumError]
                    
        let ii: Int = str_1.split(separator: " ").count
        let jj: Int = str_2.split(separator: " ").count
        let kk: Int = max(ii, jj)
        
        var dLevenstainNew = [Double]()
        if !limit {
            dLevenstainNew = Array(repeating: MAXCOUNTWORDERROR_NO_LIMIT, count: kk)
        } else {
            dLevenstainNew = Array(repeating: MAXCOUNTWORDERROR, count: kk)
        }
        
        if ii >= jj {
            for i in 0 ... ii - 1 {
                var min = MAXCOUNTWORDERROR
                if !limit {
                    min = MAXCOUNTWORDERROR_NO_LIMIT
                }
                for j in 0 ... jj - 1 {
                    if dLevenstain[j][i] < min {
                        min = dLevenstain[j][i]
                    }
                }
                dLevenstainNew[i] = min
            }
        } else {
            for j in 0 ... jj - 1 {
                var min = MAXCOUNTWORDERROR
                if !limit {
                    min = MAXCOUNTWORDERROR_NO_LIMIT
                }
                for i in 0 ... ii - 1 {
                    if dLevenstain[i][j] < min {
                        min = dLevenstain[i][j]
                    }
                }
                dLevenstainNew[j] = min
            }
        }
        
// Добавление поправочного коэффициента, который зависит от разницы в количестве сравниваемых слов
                    
        differentWord = 0
        if kk > 1 {
            var f: [Double] = []
            if kk == 2 {
                f = ERRORWORD_2
            } else if kk == 3 {
                f = ERRORWORD_3
            } else if kk == 4 {
                f = ERRORWORD_4
            } else if kk == 5 {
                f = ERRORWORD_5
            } else if kk == 6 {
                f = ERRORWORD_6
            } else {
                if !limit {
                    return MAXCOUNTWORDERROR_NO_LIMIT
                } else {
                    return MAXCOUNTWORDERROR
                }
            }
            
            for i in 0...max(ii, jj) - 1 {
                if dLevenstainNew[i] > ACCEPTCOUNTWORDERROR{
                    differentWord += f[i]
                }
            }
        }
        
        if !limit {
            if differentWord >= MAXCOUNTWORDERROR_NO_LIMIT {
                return MAXCOUNTWORDERROR_NO_LIMIT
            }
        } else {
            if differentWord >= MAXCOUNTWORDERROR {
                return MAXCOUNTWORDERROR
            }
        }
        if dLevenstain.count - 2 >= 0 && dLevenstain[0].count - 2 >= 0 {
            dLevenstainHelper = Array(repeating: Array(repeating: 0, count: dLevenstain[0].count - 1), count: dLevenstain.count - 1)
            for i in 0...dLevenstain.count - 2 {
                for j in 0...dLevenstain[0].count - 2 {
                    dLevenstainHelper[i][j] = dLevenstain[i][j]
                }
            }
            dLevenstain = dLevenstainHelper
        }

        if str_1 != str_2 {
            return (kError / Double(massiveStr1.count)) + differentWord + ERRORPLACEWORDS
        } else {
            return (kError / Double(massiveStr1.count)) + differentWord
        }
          
        
    }
