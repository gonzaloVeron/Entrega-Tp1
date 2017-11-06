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
		energia -= unMaterial.gramosMetal()
	}
	
	method darObjetosA(unCompaniero){
		return 0
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
		return longitud/1000*seccion
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
	
	method materialComidoQueMasEnergiaProduce(){}
	
	override method energiaQueProduce(){
		return materialesConsumidos.max({material=>material.energiaQueProduce()}).energiaQueProduce()
	}
	
	override method gramosDeMetal(){
		return materialesConsumidos.sum({material=>material.gramosDeMetal()})
	}
	
	override method conductividadElectrica(){
		return  materialesConsumidos.min({material=>material.conductividadElectrica()}).conductividadELectrica()
	}	
}

