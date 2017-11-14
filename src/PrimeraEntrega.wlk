class Companiero {
	var energia 
	var mochila = []
	
	constructor(_energia){
		energia = _energia
	}
	//Se van a modificar 
	method puedeRecolectar(unMaterial) //Posible template method 
		
	method recolectar(unMaterial)
	
	method consumirEnergia(unMaterial)
	
	method darObjetosA(unCompaniero)
	
	//--------------
	method aumentarEnergia(valor){
		energia += valor
	}
	method perderEnergia(valor){
		energia -= valor
	}	
	method bonusPorRecolectar(unMaterial){
		energia += unMaterial.bonusPorRecolectar()
	}
	
	method energia() = energia
	
	method mochila() = mochila
}

class Morty inherits Companiero{
	
	override method puedeRecolectar(unMaterial) = mochila.size()<3 && energia >= unMaterial.energiaParaRecolectarlo()
		
	override method recolectar(unMaterial){
		if(!self.puedeRecolectar(unMaterial)){
			self.error("No puede recolectar") 
		}
		mochila.add(unMaterial)
		self.consumirEnergia(unMaterial)
		self.bonusPorRecolectar(unMaterial)
	}
	
	override method consumirEnergia(unMaterial){
		energia -= unMaterial.energiaParaRecolectarlo()
	}
	
	override method darObjetosA(unCompaniero){
		unCompaniero.recibir(mochila)
		mochila.clear()
	}
}

/** ----------------- */

class Summer inherits Companiero{
	
	override method puedeRecolectar(unMaterial) = mochila.size() < 2 && energia >= unMaterial.energiaParaRecolectarlo()
	
	override method recolectar(unMaterial){
		if(!self.puedeRecolectar(unMaterial)){
			self.error("No puede recolectar") 
		}
		mochila.add(unMaterial)
		self.consumirEnergia(unMaterial)
		self.bonusPorRecolectar(unMaterial)
	}
	
	override method consumirEnergia(unMaterial){
		energia -= (unMaterial.energiaParaRecolectarlo() - unMaterial.energiaParaRecolectarlo() * 0.20)
	}
	
	override method darObjetosA(unCompaniero){
		unCompaniero.recibir(mochila)
		unCompaniero.restarEnergia(10)
		mochila.clear()
	}	
}

/** -------------------------------- */

class Jerry inherits Companiero{
	var buenHumor = true
	var sobreExitado = false
	
	override method puedeRecolectar(unMaterial){ //Feo
		if(sobreExitado && !buenHumor){
			return mochila.size() < 2 && energia >= unMaterial.energiaParaRecolectarlo()
		}
		else if(!sobreExitado && buenHumor){
			return mochila.size() < 3 && energia >= unMaterial.energiaParaRecolectarlo()
		}
		else if (sobreExitado && buenHumor){
			return mochila.size() < 6 && energia >= unMaterial.energiaParaRecolectarlo()
		}
		else{
			return mochila.size() < 1 && energia >= unMaterial.energiaParaRecolectarlo()
		}
	}	
		
	override method recolectar(unMaterial){ //Feo  //Falta agregar la probabilidad de perder todo
		if(!self.puedeRecolectar(unMaterial)){
			self.error("No puede recolectar") 
		}
		mochila.add(unMaterial)
		self.consumirEnergia(unMaterial)
		self.bonusPorRecolectar(unMaterial)
		
		/**        Metodo ?       */
		if(unMaterial.esUnSerVivo()){
			buenHumor = true
		}
		/**---------------------- */
	}

	override method consumirEnergia(unMaterial){
		energia -= unMaterial.energiaParaRecolectarlo()
	}
	
	override method darObjetosA(unCompaniero){
		unCompaniero.recibir(mochila)
		mochila.clear()
		buenHumor = false
	}		
}

/**-------------------------------------------------------------------------------------------------------------------------- */

class Material{

	method gramosDeMetal()
	
	method conductividadElectrica()

	method esRadiactivo() = false
	
	method energiaQueProduce() = 0
	
	method energiaParaRecolectarlo() = self.gramosDeMetal()
	
	method bonusPorRecolectar() = 0
	
	method esUnSerVivo() = false //Metodo agregado 
}


class Lata inherits Material{
	var cantMetal
	
	constructor(_cantDeMetal){
		cantMetal = _cantDeMetal
	}
	
	override method gramosDeMetal() = cantMetal
	
	override method conductividadElectrica() = self.gramosDeMetal() * 0.1
}

class Cable inherits Material{
	var longitud
	var seccion
	
	constructor(_longitud, _seccion){
		longitud = _longitud
		seccion = _seccion
	}
	
	override method gramosDeMetal() = (longitud/1000) * seccion
	
	override method conductividadElectrica() = 3 * seccion
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
	
	override method esRadiactivo() = edad >= 15
	
	method materialComidoQueMasEnergiaProduce(){
		return materialesConsumidos.max({material=>material.energiaQueProduce()})
	}
	
	override method energiaQueProduce() = self.materialComidoQueMasEnergiaProduce().energiaQueProduce()
	
	override method gramosDeMetal() = materialesConsumidos.sum({material=>material.gramosDeMetal()})
	
	method materialConsumidoConMenosConductividadElec() = materialesConsumidos.min({material=>material.conductividadElectrica()})
 
	override method conductividadElectrica() = self.materialConsumidoConMenosConductividadElec().conductividadElectrica()
	
	override method energiaParaRecolectarlo() =  super() * 2 			

	override method bonusPorRecolectar(){
		if(self.esRadiactivo()){
			return 0	
		}
		else{
			return 10
		}
	}
	
	override method esUnSerVivo() = true
}

class MateriaOscura inherits Material{
	var materialBase
	constructor (_materialBase){
		materialBase = _materialBase
	}
	override method gramosDeMetal() = materialBase.gramosDeMetal()
	
	override method conductividadElectrica() = materialBase.conductividadElectrica() / 2 
	
	override method energiaQueProduce() = materialBase.energiaQueProduce()*2
	
}

class Bateria inherits Material{
	var componentes
	
	constructor(_componentes){
		componentes = _componentes
	}
	
	override method gramosDeMetal() = componentes.sum({componente=>componente.gramosDeMetal()})
	
	override method conductividadElectrica() = 0

	override method esRadiactivo() = true
	
	override method energiaQueProduce() = self.gramosDeMetal() * 2 
	
	method componentes() = componentes
	
}

class Circuito inherits Material{
	var componentes
	
	constructor(_componentes){
		componentes = _componentes
	}
	override method gramosDeMetal() = componentes.sum({componente => componente.gramosDeMetal()})
	
	override method conductividadElectrica() = componentes.sum({componente => componente.conductividadElectrica()}) * 3

	override method esRadiactivo() = componentes.any({componente => componente.esRadiactivo()})
	
	method componentes() = componentes
}

/*---------------------------------------------------------------------------------- */

object rick{
	var companiero 
	var mochila = []
	var experimentos = []
	var componentesParaExperimento = []
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales) 
	}
	
	method experimentosQuePuedeRealizar() = experimentos.filter({experimento=> experimento.cumpleLosRequisito(mochila)})
	
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

	method aprenderNuevoExperimento(unExperimento){
		experimentos.add(unExperimento)
	}
	
	method asignarCompaniero(unCompaniero){
		companiero = unCompaniero
	}
	
	method mochila() = mochila
	
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
	override method cumpleLosRequisito(materiales) = self.hayMaterialConMasDe200GramosDeMetal(materiales) && self.hayMaterialRadiactivo(materiales)
	
	override method materialesParaRealizarlo(materiales){
		if(materiales.any({material => material.gramosDeMetal()>200 && material.esRadiactivo()})){
			return [materiales.find({material => material.gramosDeMetal()>200 && material.esRadiactivo()})]
		}
		else{
			return [self.materialConMasDe200GramosDeMetal(materiales), self.materialRadiactivo(materiales)]
		}
	}
	
	method materialConMasDe200GramosDeMetal(materiales) = materiales.find({material => material.gramosDeMetal()>200})

	method materialRadiactivo(materiales) = materiales.find({material => material.esRadiactivo()})

	override method efecto(materiales){
		rick.agregarMaterial(new Bateria(materiales))
		rick.companiero().perderEnergia(5)
	}

	method hayMaterialConMasDe200GramosDeMetal(materiales) = materiales.any({material => material.gramosDeMetal() > 200})
	
	method hayMaterialRadiactivo(materiales) = materiales.any({material => material.esRadiactivo()})	
}

class ConstruirCircuito inherits Experimento{
	override method cumpleLosRequisito(materiales) = materiales.any({material => material.conductividadElectrica() >= 5})
	
	override method efecto(materiales){
		rick.agregarMaterial(new Circuito(materiales))
	}
	
	override method materialesParaRealizarlo(materiales) = materiales.filter({material => material.conductividadElectrica() >= 5})
	
}

class ShockElectrico inherits Experimento{
	override method cumpleLosRequisito(materiales){
		return self.hayMaterialConductor(materiales) && self.hayMaterialGenerador(materiales)
	}
	
	method hayMaterialConductor(materiales) = materiales.any({material => material.conductividadElectrica() > 0})
	
	method hayMaterialGenerador(materiales) = materiales.any({material => material.energiaQueProduce() > 0})
	
	override method materialesParaRealizarlo(materiales){
		if(materiales.any({material => material.conductividadElectrica() > 0 && material.energiaQueProduce() > 0})){
			return [materiales.find({material => material.conductividadElectrica()>200 && material.energiaQueProduce()})]
		}
		else{
			return [self.materialConductor(materiales) , self.materialGenerador(materiales)]
		}
	}

	override method efecto(materiales){
		rick.companiero().aumentarEnergia(materiales.sum({material=> material.energiaQueProduce()}) * materiales.sum({material => material.conductividadElectrica()}))
	}
	
	
	method capacidadConductor(materiales) = self.materialConductor(materiales).conductividadElectrica()
	
	method capacidadGenerador(materiales) = self.materialGenerador(materiales).energiaQueProduce()
	
	method materialConductor(materiales) = materiales.find({material=>material.conductividadElectrica() > 0})

	method materialGenerador(materiales) = materiales.find({material=>material.energiaQueProduce() > 0})

}
	 