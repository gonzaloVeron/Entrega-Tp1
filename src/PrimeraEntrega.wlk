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

/*---------------------------------------------------------------------------------- */


class Bateria inherits Material{
	var componentes
	
	constructor(_componentes){
		componentes = _componentes
	}
	override method gramosDeMetal(){
		return componentes.sum({componente=>componente.gramosDeMetal()})
	}
	
	override method conductividadElectrica() = 0

	override method esRadiactivo() = false
	
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
	
	override method energiaQueProduce(){
		return 0
	}	
}

/*---------------------------------------------------------------------------------- */

class Experimento{
	method cumpleLosRequisito(materiales)	
	method efecto()
}

class ConstruirBateria inherits Experimento{
	override method cumpleLosRequisito(materiales){
		return self.hayMaterialConMasDe200GramosDeMetal(materiales) && self.hayMaterialRadiactivo(materiales)
	}
	
	override method efecto(){
		//COMPLETAR
		//rick.mochila().add(new Bateria())
	}
	
	//---
	
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
	
	method efecto(){
		//COMPLETAR
		//rick.mochila().add(new Circuito())
	}
}

class ShockElectrico inherits Experimento{
	override method cumpleLosRequisito(materiales){
		return materiales.any({material => material.conductividadElectrica() > 0}) && materiales.any({materiales => material.energiaQueProduce() > 0})
	}
	
	method efecto(){
		rick.companiero().aumentarEnergia(//COMPLETAR)	
	}
}

object rick{
	var companiero 
	var mochila = [] //infinita
	var experimentos = []
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales) 
	}
	
	method experimentosQuePuedeRealizar(){
		return experimentos.filter({experimento=> experimento.requisito(mochila)})
	}
	
	method realizar(unExperimento){
		if(!self.experimentosQuePuedeRealizar().contains(unExperimento)){
			self.error("No puede realizar el experimento")
		}	
		self.removerMaterialesUsados(self.buscarMateriales(unExperimento))
		unExperimento.efecto()
	}

	//----
		
	method aprenderNuevoExperimento(unExperimento){
		experimentos.add(unExperimento)
	}
	
	method companiero(unCompaniero){
		companiero = unCompaniero
	}
	
	method removerMaterialesUsados(materiales){
		mochila.removeAll(materiales)
	}	
	
	//----
	
	method companiero(){
		return companiero
	}
	
	method mochila(){
		return mochila
	}
}
		



