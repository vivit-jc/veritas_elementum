class Material

attr_accessor :know_materials, :have_materials
attr_reader :material_atoms

  def initialize
  	p "init material"
    atoms = ATOMS.clone
    atoms_proto = []
    atoms_proto += atoms + atoms
    6.times do
      atoms_proto.push atoms.sample
    end
    atoms_proto.shuffle!

    @know_materials = Hash.new
    MATERIALS.each{|m|@know_materials[m] = nil}
    @have_materials = Hash.new
    MATERIALS.each{|m|@have_materials[m] = 0}
    @material_atoms = Hash.new
    MATERIALS.each_with_index{|m,i|@material_atoms[m] = atoms_proto[i]}


    #テスト用：ランダムに持ってる素材を追加する
    100.times do 
    	@have_materials[MATERIALS.sample] += 1
    end
    #テスト用：ランダムに素材の元素を知っている
    6.times do
    	mat = MATERIALS.sample
    	@know_materials[mat] = @material_atoms[mat]
    end

  end

  def have_array #[[持ってる素材,その個数],[持ってる素材,その個数]...]を返す
  	materials = []
  	@have_materials.each do |k,v|
  		materials.push [k,v] if v > 0
  	end
  	return materials
  end

end