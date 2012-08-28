def load()
  sample=[]
  lines = IO.readlines("input.csv")
  lines.each do |line|
    sample+=[line.chomp.split(",")]
  # puts line.split(",")
  end
  return sample
end

def getColumn(a=[], col, s)
  temp=[]
  (s..a.length-1).each do |val|
  # puts a[val][col]
    temp.push a[val][col]
  end
  # puts temp
  return temp
end

def getChances(var, arr)
  temp={}
  arr.each do |i|
    if temp[i]
    temp[i]+=1
    else
    temp[i]=1
    end
  end
  return temp
end

def getJointChances(arr, cls, keyArr, keyCl)
  temp={}
  t=[]
  (0..arr.length-1).each do |i|
    if temp[arr[i]]
      if temp[arr[i]][cls[i]]
      temp[arr[i]][cls[i]]+=1
      else
      temp[arr[i]][cls[i]]=1
      end
    else
      temp[arr[i]]={cls[i]=>1}
    end
  end
  temp.keys.each do |i|
    temp[i].keys.each do |j|

      if temp[i][j]
        puts "i-> j = #{temp[i][j]}, keyArr = #{keyArr[i]}, i=#{i}, j=#{j}"
        q=temp[i][j].to_f/keyArr[i].to_f
        if temp[i][j]=1
          t.push([i, j, q-0.001])
        else
          t.push([i, j, q])
        end
      else
        t.push([i,j, 0.001])
      end
    end
  end
  t.each do |i|
    temp[i[0]][i[1]]=i[2]
  end
  return temp
end

def makeDecision(v1,v2,c1, c2, chances, jChances, l)
  yes=jChances[v1][c1]["yes"]*jChances[v2][c2]["yes"]*(chances["yes"].to_f/l)
  no=jChances[v1][c1]["no"]*jChances[v2][c2]["no"]*(chances["no"].to_f/l)
  if yes > no
    ans= "yes"
  else
    ans="no"
  end
  return "yes= #{yes} and no=#{no}, Class= #{ans}"
end

def init()
  sample = load
  step={}
  chances={}
  jChances={}
  baye={}
  (0..sample[0].length-1).each do |var|
    step[sample[0][var]]=getColumn(sample, var, 1)
  end

  step.keys.each do |key|
    chances[key]= getChances(key, step[key])
  end
  (0..chances.keys.length-2).each do |i|
    _jChances=getJointChances(getColumn(sample, i, 1),getColumn(sample, chances.keys.length-1, 1), chances[chances.keys[i]], chances[chances.keys[chances.keys.length-1]])
    jChances[chances.keys[i]]=_jChances
  end
  
  puts "Enter First Variable"
  v1= gets().chomp()
  puts "Enter Value for #{v1}"
  c1=gets().chomp()
  puts "Enter Second Variable"
  v2= gets().chomp()
  puts "Enter Value for #{v2}"
  c2=gets().chomp()
  puts makeDecision(v1, v2, c1, c2, chances["class"],jChances, sample.length-2)
end


init()
