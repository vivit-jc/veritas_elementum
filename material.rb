class Material

attr_accessor :know_materials, :have_materials
attr_reader :material_atoms

  def initialize
  	p "init material"
    atoms = ATOMS.clone
    @material_atoms = []
    @material_atoms += atoms + atoms
    6.times do
      @material_atoms.push atoms.sample
    end
    @material_atoms.shuffle!

    @know_materials = Hash.new
    MATERIALS.each{|m|@know_materials[m] = 0}
    @have_materials = Hash.new
    MATERIALS.each{|m|@have_materials[m] = 0}

    #テスト用：ランダムに持ってる素材を追加する
    100.times do 
    	@have_materials[MATERIALS.sample] += 1
    end
    p @have_materials

  end

  def have_array #[[持ってる素材,その個数],[持ってる素材,その個数]...]を返す
  	materials = []
  	@have_materials.each do |k,v|
  		materials.push [k,v] if v > 0
  	end
  	return materials
  end

end