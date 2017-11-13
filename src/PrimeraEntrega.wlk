class Companiero {
	var energia 
	var mochila = []
	
	constructor(_energia){
		energia = _energia
	}
	
	method energia(){
		return energia
	}
	
	method mochila(){
		return mochila
	}
	
	method puedeRecolectar(unMaterial){
		return mochila.size()<3 && (energia >= unMaterial.energiaParaRecolectarlo())
	}
	
	method recolectar(unMaterial){
		if(!self.puedeRecolectar(unMaterial)){
			self.error("No puede recolectar") 
		}
		mochila.add(unMaterial)
		self.consumirEnergia(unMaterial)
		self.bonusPorRecolectar(unMaterial)
	}
	
	method bonusPorRecolectar(unMaterial){
		energia += unMaterial.bonusPorRecolectar()
	}

	method consumirEnergia(unMaterial){
		energia -= unMaterial.energiaAlRecolectar()
	}
	
	method darObjetosA(unCompaniero){
		unCompaniero.recibir(mochila)
		mochila.clear()
	}
	
	//--
	
	method aumentarEnergia(valor){
		energia += valor
	}
	method perderEnergia(valor){
		energia -= valor
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
	
	method energiaParaRecolectarlo(){
		return self.gramosDeMetal()
	}
	
	method energiaAlRecolectar(){
		return self.gramosDeMetal()
	}
	
	method bonusPorRecolectar(){
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

	override method energiaParaRecolectarlo(){
		return self.gramosDeMetal()*2
	}
	
	override method energiaAlRecolectar(){
		return super()*2 			
	}
	
		
	override method bonusPorRecolectar(){
		if(self.esRadiactivo()){
			return 0	
		}
		else{
			return 10
		}
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
		return materialBase.energiaQueProduce()*2
	} 
}
class Bateria inherits Material{
	var componentes
	
	constructor(_componentes){
		componentes = _componentes
	}
	override method gramosDeMetal(){
		return componentes.sum({componente=>componente.gramosDeMetal()})
	}
	
	override method conductividadElectrica() = 0

	override method esRadiactivo() = true
	
	override method energiaQueProduce(){
		return 2*self.gramosDeMetal()
	}
}

class Circuito inherits Material{
	var componentes
	
	constructor(_componentes){
		componentes = _componentes
	}
	override method gramosDeMetal(){
		return componentes.sum({componente => componente.gramosDeMetal()})
	}
	
	override method conductividadElectrica() = componentes.sum({componente => componente.conductividadElectrica()}) * 3

	override method esRadiactivo() = componentes.any({componente => componente.esRadiactivo()})
}
/*---------------------------------------------------------------------------------- */

object rick{
	var companiero 
	var mochila = [] //infinita
	var experimentos = []
	var componentesParaExperimento = []
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales) 
	}
	
	method experimentosQuePuedeRealizar(){
		return experimentos.filter({experimento=> experimento.cumpleLosRequisito(mochila)})
	}
	
	method realizar(unExperimento){
		if(!self.experimentosQuePuedeRealizar().contains(unExperimento)){
			self.error("No puede realizar el experimento")
		}
		self.componentesParaExperimento(unExperimento.materialesParaRealizarlo(mochila))
		unExperimento.efecto(componentesParaExperimento)	
		self.removerMateriales(componentesParaExperimento)
	}
	
	
	method removerMateriales(materiales){
		mochila.removeAll(materiales)
	}
	
	//----
	method aprenderNuevoExperimento(unExperimento){
		experimentos.add(unExperimento)
	}
	
	method asignarCompaniero(unCompaniero){
		companiero = unCompaniero
	}
	
	method mochila(){
		return mochila
	}
	
	method agregarMaterial(unMaterial){
		mochila.add(unMaterial)
	}
	
	method companiero() = companiero
	
	method componentesParaExperimento(componentes){
		componentesParaExperimento = componentes
	}
}


class Experimento{
	method cumpleLosRequisito(materiales)	
	method efecto(materiales)
	method materialesParaRealizarlo(materiales)
}


class ConstruirBateria inherits Experimento{
	override method cumpleLosRequisito(materiales){
		return self.hayMaterialConMasDe200GramosDeMetal(materiales) && self.hayMaterialRadiactivo(materiales)
	}
	
	//Mejorar
	override method materialesParaRealizarlo(materiales){
		if(materiales.any({material => material.gramosDeMetal()>200 && material.esRadiactivo()})){
			return [materiales.find({material => material.gramosDeMetal()>200 && material.esRadiactivo()})]
		}
		else{
			return [materiales.find({material => material.gramosDeMetal()>200}) , materiales.find({material => material.esRadiactivo()})]
		}
	}

	/////Arreglar
	override method efecto(materiales){
		rick.agregarMaterial(new Bateria(materiales))
		rick.companiero().perderEnergia(5)
	}
	////

	//------------	
	method hayMaterialConMasDe200GramosDeMetal(materiales){
		return materiales.any({material => material.gramosDeMetal() > 200})
	}
	
	method hayMaterialRadiactivo(materiales){
		return materiales.any({material => material.esRadiactivo()})	
	}

}

class ConstruirCircuito inherits Experimento{
	override method cumpleLosRequisito(materiales){
		return materiales.any({material => material.conductividadElectrica() >= 5})
	}
	
	//Arreglar
	override method efecto(materiales){
		rick.agregarMaterial(new Circuito(materiales))
	}
	
	override method materialesParaRealizarlo(materiales){
		return materiales.filter({material => material.conductividadElectrica() >= 5})
	}

}




class ShockElectrico inherits Experimento{
	override method cumpleLosRequisito(materiales){ //Bien
		return materiales.any({material => material.conductividadElectrica() > 0}) && materiales.any({material => material.energiaQueProduce() > 0})
	}
	
	override method materialesParaRealizarlo(materiales){
		return [self.materialConductor(materiales) , self.materialGenerador(materiales)]
	}
	
	method materialConductor(materiales){
		return materiales.find({material=>material.conductividadElectrica() > 0}) //Es un objeto
	}

	method materialGenerador(materiales){
		return materiales.find({material=>material.energiaQueProduce() > 0}) //Es un objeto
	}
	
	method capacidadConductor(materiales){
		return self.materialConductor(materiales).conductividadElectrica()
	}
	
	method capacidadGenerador(materiales){
		return self.materialGenerador(materiales).energiaQueProduce()
	}
	 
	// Revisar 
	override method efecto(materiales){
		rick.companiero().aumentarEnergia(self.capacidadGenerador(materiales) * self.capacidadConductor(materiales))
	}
	
}
	