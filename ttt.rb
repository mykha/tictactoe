#игра крестики нолики
#тренировочное задание по работе с массивами и хэшами
@cor = {"A"=>1, "B"=>2, "C"=>3}
#рисует чистую матрицу (чистит поле)
def clear_mx
  puts "Новая игра"
  puts "Для выхода из игры нажмите q"
  @mx = Array.new(4){Array.new(4)}
  @mx.each_index do |r| 
    if r != 0
      @mx[r][0] = ('A'..'C').to_a[r-1]
      @mx[0][r] = ('1'..'3').to_a[r-1]
    end
  end
  draw_field @mx
end

@xo = Hash.new{|h,k| h[k]=k}
# nil как ключ хэша используется ради эксперимента
@xo.merge!({true => 'X', false => 'O', nil=> " "})
#рисует матрицу с текущими ходами
def draw_field m
  m.each do |s|
    s.each do |r|
      print"|#{@xo[r]}"
    end
    puts "|"
  end
end
#определяет массив свободных координат матрицы
def space m
  sp = []
    m.each_index do |s|
      m[s].each_index do |r|
        if r!= 0 && s!=0
          if m[s][r]==nil
            sp << s*10 + r
          end
        end
      end
    end
    return sp
end
#ставит ход пользователя или компа в матрицу
def put_turn s_us
  if s_us.is_a? String
    if ("A".."C")===s_us[0] && ("1".."3")===s_us[1]
      row = @cor[s_us[0]]
      col = s_us[1].to_i
      return nil if @mx[row][col]!=nil
      @mx[row][col]=true
    end
  elsif s_us.is_a? Integer
    row = s_us/10
    col = s_us-row*10
    puts "row #{@cor.invert[row]} , col #{col}"
    if (1..3)===row && (1..3)===col
      @mx[row][col]=false
    end
  else
    return nil
  end
end
#проверяет, не победил ли кто-то: комп или юзер
def check_win m
  win_lengh = 3
  if m[1][1]==true && m[2][2]==true && m[3][3]==true
    return win true 
  end
  if m[1][1]==false && m[2][2]==false && m[3][3]==false
    return win false
  end
  if m[1][3]==false && m[2][2]==false && m[3][1]==false
    return win false 
  end
  if m[1][3]==true && m[2][2]==true && m[3][1]==true
    return win true 
  end
  (1..m.size-1).each do |r|
    cw = 0
    uw = 0
    cwv = 0
    uwv = 0
#    puts m[r].inspect
    (1..m[r].size-1).each do |c|
      if m[r][c]==true
        uw+=1
        cw-=1
      elsif m[r][c]== false
        uw-=1
        cw+=1
      end
      if uw>=win_lengh or cw>=win_lengh
        return win uw>cw
      end
      if m[c][r]==true 
        uwv+=1
        cwv-=1
      elsif m[c][r]==false
        uwv-=1
        cwv+=1
      end
      if uwv>=win_lengh or cwv>=win_lengh
        return win uwv>cwv
      end
    end
  end
  return nil
end
#выводит сообщение в зависимости от того кто победил
def win user
  if user 
    puts "Поздравляю! Вы выиграли!"
  else
    puts "Игра окончена. Компьютер выиграл"
  end
  return user
end

start = true
#цикл
loop do
#рисуем чистое поле
  clear_mx if start
  begin
    start = false
    puts "Ваш ход"
    puts "введите координаты (буква лат.+ цифра)"
    s_us = gets.strip.upcase
    exit if s_us[0] == "Q" 
    #ставим ход пользователя в матрицу
    wrong_turn = put_turn(s_us) == nil 
    puts "Неправильные координаты, попробуйте еще раз" if wrong_turn
  end while wrong_turn
#снова рисуем поле, но уже с ходом юзера
  draw_field @mx

  puts "Ход компьютера"
  #ход компьютера
  #определяем массив свободных клеток
  sp = space @mx
  #если нет уже свободных и до сих пор не окончена 
  #игра, то значит это ничья
  if sp.size!=0
    #определяем ход компа рандомно из всех свободных
    s_co = sp[rand(0..sp.size-1)]
    #puts "Массив пустых #{sp.inspect}
    #рисуем поле с ходом компа
    put_turn(s_co)
    draw_field @mx
    #если кто-то выиграл то игра начинается с начала
    start = true if (check_win @mx) != nil
  else
    puts "Игра окончена. Ничья !"
    start = true
  end
end


