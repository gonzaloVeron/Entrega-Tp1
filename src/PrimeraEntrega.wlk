class Companiero {
	var energia 
	var mochila = []
	var companieroCreador
	constructor(_energia,unCreador){
		energia = _energia
		companieroCreador = unCreador
	}
	method cambiarCompanieroCreador(unCreador){
		companieroCreador = unCreador
	}

	method puedeRecolectar(unMaterial){ //Template method
		return self.tieneEnergia(unMaterial) && self.cuantoPuedeCargar()
	}
		
	method cuantoPuedeCargar()	
		
	method recolectar(unMaterial)
	
	method consumirEnergia(unMaterial)
	
	//--------------
	method tieneEnergia(unMaterial) = energia >= unMaterial.energiaParaRecolectarlo()
	
	method aumentarEnergia(valor){
		energia += valor
	}
	method perderEnergia(valor){
		energia -= valor
	}	
	method bonusPorRecolectar(unMaterial){
		energia += unMaterial.bonusPorRecolectar()
	}
	method alteracionPorRecolectar(unMaterial){
		unMaterial.accionesPorRecolectar(self)
	}
	method quitarObjeto(unElemento){
		if(mochila.contains(unElemento)){
			mochila.remove(unElemento)
		}
	}
	
	method energia() = energia
	
	method mochila() = mochila
	
	method mochilaEstaVacia() =  mochila.isEmpty()
	
	method verificarQuePuedeRecolectar(unMaterial){
		if(!self.puedeRecolectar(unMaterial)){
			self.error("No puede recolectar")
		}
	}
	
	method darObjetosACompanieroCreador(){
		companieroCreador.recibir(mochila)
		mochila.clear()
	}
	
}

/** ---------------------------- */

class Morty inherits Companiero{
	
	override method cuantoPuedeCargar() = mochila.size() < 3 
		
	override method recolectar(unMaterial){
		self.verificarQuePuedeRecolectar(unMaterial)
		self.alteracionPorRecolectar(unMaterial)
		mochila.add(unMaterial)
		self.consumirEnergia(unMaterial)
		self.bonusPorRecolectar(unMaterial)
	}
	
	override method consumirEnergia(unMaterial){
		energia -= unMaterial.energiaParaRecolectarlo()
	}
}

/** ----------------- */

class Summer inherits Companiero{
	
	override method cuantoPuedeCargar() = mochila.size() < 2 
	
	override method recolectar(unMaterial){
		self.verificarQuePuedeRecolectar(unMaterial)
		mochila.add(unMaterial)
		self.consumirEnergia(unMaterial)
		self.bonusPorRecolectar(unMaterial)
	}
	
	override method consumirEnergia(unMaterial){
		energia -= (unMaterial.energiaParaRecolectarlo() - unMaterial.energiaParaRecolectarlo() * 0.20)
	}
	
	override method darObjetosACompanieroCreador(){
		companieroCreador.recibir(mochila)
		mochila.clear()
	}	
}

/** -------------------------------- */
class Jerry inherits Companiero{
	var humor
	
	override method cuantoPuedeCargar() = mochila.size() < humor.cantidadQuePuedeLlevar()
	
	override method recolectar(unMaterial){
		humor.pierdeTodo(mochila)
		self.verificarQuePuedeRecolectar(unMaterial)
		mochila.add(unMaterial)
		self.consumirEnergia(unMaterial)
		self.bonusPorRecolectar(unMaterial)
		self.recolectoUnSerVivo(unMaterial)
	}
	
	override method consumirEnergia(unMaterial){
		energia -= unMaterial.energiaParaRecolectarlo()
	}
	
	/*------------------------ */	
	method recolectoUnSerVivo(unMaterial){
		if(unMaterial.esUnSerVivo()){
			humor = new BuenHumor()
		}
	}
	
	method recolectoMaterialRadiactivo(unMaterial){
		if(unMaterial.esRadiactivo()){
			humor = new SobreExitado()
		}
	}		
}

/**---------------------------------- */

class Humor{
	method cantidadQuePuedeLlevar()
	
	method pierdeTodo(unaMochila){}
}

class BuenHumor inherits Humor{
	override method cantidadQuePuedeLlevar() = 3
}

class MalHumor inherits Humor{
	override method cantidadQuePuedeLlevar() = 1
}

class SobreExitado inherits Humor{
	override method cantidadQuePuedeLlevar() = 6
	
	override method pierdeTodo(unaMochila){
		if(1.randonUpTo(4)){
			unaMochila.clear()
		}
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
	
	method esUnSerVivo() = false 
	
	method accionesPorRecolectar(unRecolector){}
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

class ParasitoAlienigena inherits Material{
	var acciones = []
	constructor(unaListaDeAcciones){
		acciones = unaListaDeAcciones
	}
	
	override method gramosDeMetal()= 10
	
	override method conductividadElectrica() = 0
	
	override method energiaQueProduce() = 5
			
	override method esUnSerVivo() = true 
	
	override method accionesPorRecolectar(unRecolector){
		acciones.forEach({accion=>accion.efecto(unRecolector)})
	}
}

/*---------------------------------------------------------------------------------- */
class Accion{
	method efecto(unRecolector)
}

class Apurar inherits Accion{
	override method efecto(unRecolector){
		unRecolector.darObjetosACompanieroCreador()
	}
}
class Descartar inherits Accion{
	override method efecto(unRecolector){
		if(! unRecolector.mochilaEstaVacia()){
		unRecolector.quitarObjeto(unRecolector.mochila().anyOne())
		}
	}
}
class Incrementar inherits Accion{
	var porcenEnergia
	constructor(unPorcentajeDeEnergia){
		porcenEnergia = unPorcentajeDeEnergia
	}
	override method efecto(unRecolector){
		unRecolector.aumentarEnergia((unRecolector.energia()*porcenEnergia)/100)
	}
}
class Decrementar inherits Incrementar{
	override method efecto(unRecolector){
		unRecolector.bajarEnergia((unRecolector.energia()*porcenEnergia)/100)
	}
}
class EncontrarOculto inherits Accion{
	var elementoOculto 
	constructor(unElemento){
		elementoOculto = unElemento 
	}
	override method efecto(unRecolector){
		unRecolector.recolectar(elementoOculto)
	}
}
/*---------------------------------------------------------------------------------- */

object rick{
	var companiero 
	var mochila = []
	var experimentos = []
	var estrategia = new AlAzar()////parte 5
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales) 
	}
	
	method experimentosQuePuedeRealizar() = experimentos.filter({experimento=> experimento.cumpleLosRequisito(mochila)})
	
	method realizar(unExperimento){
		if(!self.experimentosQuePuedeRealizar().contains(unExperimento)){
			self.error("No puede realizar el experimento")
		}
		var componentesParaExperimento = unExperimento.materialesParaRealizarlo(mochila, estrategia)//parte 5
		unExperimento.efecto(componentesParaExperimento)	
		self.removerMateriales(componentesParaExperimento)
	}
	
	method removerMateriales(materiales){////parte 5
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
	
	method estrategiaDeSeleccion(unaEstrategia){ ////parte 5
		estrategia = unaEstrategia
	}
	
	method estrategiaDeSeleccion() = estrategia ////parte 5
}


class Experimento{
	method cumpleLosRequisito(materiales)	
	method efecto(materiales)
	method materialesParaRealizarlo(materiales, estrategia){
		if(materiales.any(self.cumpleTodosLosRequisitos())){
			return [estrategia.seleccion(materiales.filter(self.cumpleTodosLosRequisitos()))]
		}
		else{
			return [estrategia.seleccion(materiales.filter(self.cumpleLaPrimeraCondicion())), estrategia.seleccion(materiales.filter(self.cumpleLaSegundaCondicion()))]
		}
	}
	method cumpleTodosLosRequisitos()
	method cumpleLaPrimeraCondicion()
	method cumpleLaSegundaCondicion()
}


class ConstruirBateria inherits Experimento{
	override method cumpleLosRequisito(materiales) = self.hayMaterialConMasDe200GramosDeMetal(materiales) && self.hayMaterialRadiactivo(materiales)

	method hayMaterialConMasDe200GramosDeMetal(materiales) = materiales.any({material => material.gramosDeMetal() > 200})
	
	method hayMaterialRadiactivo(materiales) = materiales.any({material => material.esRadiactivo()})	

	/* 
	override method materialesParaRealizarlo(materiales, estrategia){
		if(materiales.any({material => material.gramosDeMetal()>200 && material.esRadiactivo()})){
			return [estrategia.seleccion(materiales.filter({material => material.gramosDeMetal()>200 && material.esRadiactivo()}))]
		}
		else{
			return [estrategia.seleccion(self.materialesConMasDe200GramosDeMetal(materiales)), estrategia.seleccion(self.materialRadiactivo(materiales))]
		}
	}
	*/
	
	override method cumpleTodosLosRequisitos() = {material => material.gramosDeMetal()>200 && material.esRadiactivo()}
	
	override method cumpleLaPrimeraCondicion() = {material => material.gramosDeMetal()>200}
	
	override method cumpleLaSegundaCondicion() = {material => material.esRadiactivo()}
	
	//borrar??
	method materialesConMasDe200GramosDeMetal(materiales) = materiales.filter({material => material.gramosDeMetal()>200})

	//borrar??
	method materialRadiactivo(materiales) = materiales.filter({material => material.esRadiactivo()})

	override method efecto(materiales){
		rick.agregarMaterial(new Bateria(materiales))
		rick.companiero().perderEnergia(5)
	}

}

class ConstruirCircuito inherits Experimento{
	override method cumpleLosRequisito(materiales) = materiales.any(self.cumpleTodosLosRequisitos())
	
	override method efecto(materiales){
		rick.agregarMaterial(new Circuito(materiales))
	}
	
	////parte 5 
	override method materialesParaRealizarlo(materiales, estrategia) = materiales.filter(self.cumpleTodosLosRequisitos())
	
	override method cumpleTodosLosRequisitos() = {material => material.conductividadElectrica() >= 5}
	override method cumpleLaPrimeraCondicion() = {}
	override method cumpleLaSegundaCondicion() = {}
}

class ShockElectrico inherits Experimento{
	override method cumpleLosRequisito(materiales){
		return self.hayMaterialConductor(materiales) && self.hayMaterialGenerador(materiales)
	}
	
	method hayMaterialConductor(materiales) = materiales.any({material => material.conductividadElectrica() > 0})
	
	method hayMaterialGenerador(materiales) = materiales.any({material => material.energiaQueProduce() > 0})
	
	/* 
	override method materialesParaRealizarlo(materiales, estrategia){
		if(materiales.any({material => material.conductividadElectrica() > 0 && material.energiaQueProduce() > 0})){
			return [estrategia.seleccion(materiales.filter({material => material.conductividadElectrica()>0 && material.energiaQueProduce()>0}))]
		}
		else{
			return [estrategia.seleccion(self.materialConductor(materiales)) , estrategia.seleccion(self.materialGenerador(materiales))]
		}
	}
*/
	override method cumpleTodosLosRequisitos() = {material => material.conductividadElectrica() > 0 && material.energiaQueProduce() > 0}
	
	override method cumpleLaPrimeraCondicion() = {material=>material.conductividadElectrica() > 0}
	
	override method cumpleLaSegundaCondicion() = {material=>material.energiaQueProduce() > 0}
	
	override method efecto(materiales){
		rick.companiero().aumentarEnergia(materiales.sum({material=> material.energiaQueProduce()}) * materiales.sum({material => material.conductividadElectrica()}))
	}
	
	/* 
	method capacidadConductor(materiales) = self.materialConductor(materiales).conductividadElectrica()
	
	method capacidadGenerador(materiales) = self.materialGenerador(materiales).energiaQueProduce()
	
	method materialConductor(materiales) = materiales.filter({material=>material.conductividadElectrica() > 0})

	method materialGenerador(materiales) = materiales.filter({material=>material.energiaQueProduce() > 0})
	*/
	
}
	 
	 
class Estrategia{////parte 5
	method seleccion(componentes)
}

class AlAzar inherits Estrategia{
	override method seleccion(componentes) = componentes.anyOne()
}

class MenorCantidaDeMetal inherits Estrategia{
	override method seleccion(componentes) = componentes.min({componente=>componente.gramosDeMetal()})
}

class MejorGeneradorElectrico inherits Estrategia{
	override method seleccion(componentes) = componentes.max({componente=>componente.energiaQueProduce()})
}

class Ecologico inherits Estrategia{
	override method seleccion(componentes) = componentes.findOrElse({componente=>componente.esUnSerVivo()}, {componentes.findOrElse({componente=>!componente.esRadiactivo()}, {componentes.anyOne()})})
} 
