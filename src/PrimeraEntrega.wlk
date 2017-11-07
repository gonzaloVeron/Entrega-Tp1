class Companiero {
	var energia 
	var mochila = #{}
	
	constructor(_energia){
		energia = _energia
	}
	
	method puedeRecolectar(unMaterial){
		return mochila.size()<3 && (energia >= unMaterial.gramosDeMetal())
	}
	
	method recolectar(unMaterial){
		if(!self.puedeRecolectar(unMaterial)){
			self.error("No puede recolectar") 
		}
		mochila.add(unMaterial)
		self.consumirEnergia(unMaterial)
	}

	method consumirEnergia(unMaterial){
		energia -= unMaterial.gramosDeMetal()
	}
	
	method darObjetosA(unCompaniero){
		
	} 
}

class Material{

	method gramosDeMetal()
	method conductividadElectrica()

	method esRadiactivo(){
		return false
	}
	
	method energiaQueProduce(){
		return 0
	}
	
}


class Lata inherits Material{
	var cantMetal
	
	constructor(_cantDeMetal){
		cantMetal = _cantDeMetal
	}
	
	override method gramosDeMetal(){
		return cantMetal
	}
	
	override method conductividadElectrica(){
		return self.gramosDeMetal()*0.1
	}
}

class Cable inherits Material{
	var longitud
	var seccion
	
	constructor(_longitud, _seccion){
		longitud = _longitud
		seccion = _seccion
	}
	
	override method gramosDeMetal(){
		return (longitud/1000)*seccion
	}
	
	override method conductividadElectrica(){
		return 3*seccion 
	}
}


class Fleeb inherits Material{
	var edad
	var materialesConsumidos = [] 
	constructor(_edad){
		edad = _edad
	}
	
	method consumirMaterial(unMaterial){
		materialesConsumidos.add(unMaterial)	
	}
	
	override method esRadiactivo(){
		return edad>=15
	}
	
	method materialComidoQueMasEnergiaProduce(){
		return materialesConsumidos.max({material=>material.energiaQueProduce()})
	}
	
	override method energiaQueProduce(){
		return self.materialComidoQueMasEnergiaProduce().energiaQueProduce()
	}
	
	override method gramosDeMetal(){
		return materialesConsumidos.sum({material=>material.gramosDeMetal()})
	}
	method materialConsumidoConMenosConductividadElec(){
		return materialesConsumidos.min({material=>material.conductividadElectrica()})
	}
	override method conductividadElectrica(){
		return  self.materialConsumidoConMenosConductividadElec().conductividadElectrica()
	}	
}
class MateriaOscura inherits Material{
	var materialBase
	constructor (_materialBase){
		materialBase = _materialBase
	}
	override method gramosDeMetal(){
		return materialBase.gramosDeMetal()
	}
	
	override method conductividadElectrica(){
		return materialBase.conductividadElectrica() / 2 
	}
	
	override method energiaQueProduce(){
		return materialBase.energiaQueProduce()
	} 
}
