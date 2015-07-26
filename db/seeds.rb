# coding: utf-8
user = User.find_by_username 'lucien.farstein@gmail.com'
!user.nil? && User.create(username: 'lucien.farstein@gmail.com', password: 'toto555500')

[['#CECECE','Argenté'],
 ['#F3F3D6','Beige'],
 ['#FFFFFF','Blanc'],
 ['#00b2e7','Bleu'],
 ['#be0926','Bordeaux'],
 ['#614E1A','Bronze'],
 ['#FEC3AC','Chair'],
 ['#B36700','Cuivré'],
 ['#FFFF99','Doré'],
 ['#FEFEE0','Écru'],
 ['#e41370','Fuchsia'],
 ['#8c8c8c','Gris'],
 ['#fffff0','Ivoire'],
 ['#fcea10','Jaune'],
 ['#94812B','Kaki'],
 ['#935b38','Marron'],
 ['#D473D4','Mauve'],
 ['#FFF','Multicolore'],
 ['#000000','Noir'],
 ['#f29400','Orange'],
 ['#811453','Prune'],
 ['#f2aac6','Rose'],
 ['#FF0000','Rouge'],
 ['#463F32','Taupe'],
 ['#FFFFF0','Transparent'],
 ['#00a096','Turquoise'],
 ['#007325','Vert'],
 ['#980d7d','Violet']].each do |e|
  Color.create!(hex: e[0], name: e[1])
end
