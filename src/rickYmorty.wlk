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

	method puedeRecolectar(unMaterial){
		return self.tieneEnergia(unMaterial) && self.cuantoPuedeCargar()
	}
		
	method cuantoPuedeCargar()	
		
	method recolectar(unMaterial){
		self.verificarQuePuedeRecolectar(unMaterial)
		mochila.add(unMaterial)
		self.consumirEnergia(unMaterial)
		self.bonusPorRecolectar(unMaterial)
	}
	
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
		unMaterial.bonusPorRecolectar(self)
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
		super(unMaterial)
		self.alteracionPorRecolectar(unMaterial)
	}
	
	override method consumirEnergia(unMaterial){
		energia -= unMaterial.energiaParaRecolectarlo()
	}
	
	method alteracionPorRecolectar(unMaterial){
		unMaterial.accionesPorRecolectar(self)
	}
}

/** ----------------- */

class Summer inherits Companiero{
	
	override method cuantoPuedeCargar() = mochila.size() < 2 
	
	override method consumirEnergia(unMaterial){
		energia -= (unMaterial.energiaParaRecolectarlo() - unMaterial.energiaParaRecolectarlo() * 0.20)
	}
	
	override method darObjetosACompanieroCreador(){
		super()
		energia -= 10
	}	
}

/** -------------------------------- */
class Jerry inherits Companiero{
	var humor
	
	constructor(_energia,unCreador,unHumor) = super(_energia,unCreador) {
		energia = _energia
		companieroCreador = unCreador
		humor = unHumor
	}
	
	override method cuantoPuedeCargar() = mochila.size() < humor.cantidadQuePuedeLlevar()
	
	override method recolectar(unMaterial){
		humor.pierdeTodo(mochila)
		super(unMaterial)
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
	
	method bonusPorRecolectar(alguien){
		alguien.aumentarEnergia(0)
	}
	
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

	override method bonusPorRecolectar(alguien){
		if(self.esRadiactivo()){
			alguien.aumentarEnergia(0)
		}else{
			alguien.aumentarEnergia(10)
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

/** ---------------------------------------------------------------------- */

class MaterialExperimental inherits Material{
	var componentes
	constructor(unosComponentes){
		componentes = unosComponentes
	}
	
	method componentes() = componentes
	
	override method gramosDeMetal() = componentes.sum({componente => componente.gramosDeMetal()})
}

class Bateria inherits MaterialExperimental{
	
	override method conductividadElectrica() = 0

	override method esRadiactivo() = true
	
	override method energiaQueProduce() = self.gramosDeMetal() * 2 
		
}

class Circuito inherits MaterialExperimental{
	
	override method conductividadElectrica() = componentes.sum({componente => componente.conductividadElectrica()}) * 3

	override method esRadiactivo() = componentes.any({componente => componente.esRadiactivo()})

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
	var estrategia = new AlAzar()
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales) 
	}
	
	method experimentosQuePuedeRealizar() = experimentos.filter({experimento=> experimento.cumpleLosRequisito(mochila)})
	
	method realizar(unExperimento){
		if(!unExperimento.cumpleLosRequisito(mochila)){
			self.error("No puede realizar el experimento")
		}
		var componentesParaExperimento = unExperimento.materialesParaRealizarlo(mochila, estrategia)
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
	
	method estrategiaDeSeleccion(unaEstrategia){
		estrategia = unaEstrategia
	}
	
	method estrategiaDeSeleccion() = estrategia
}



class Experimento{
	method cumpleLosRequisito(materiales)	
	method efecto(materiales)
	method materialesParaRealizarlo(materiales, estrategia) = [estrategia.seleccion(materiales.filter(self.cumpleLaPrimeraCondicion())), estrategia.seleccion(materiales.filter(self.cumpleLaSegundaCondicion()))]
	method cumpleLaPrimeraCondicion()
	method cumpleLaSegundaCondicion()
}

class ConstruirBateria inherits Experimento{
	override method cumpleLosRequisito(materiales) = self.hayMaterialConMasDe200GramosDeMetal(materiales) && self.hayMaterialRadiactivo(materiales)

	method hayMaterialConMasDe200GramosDeMetal(materiales) = materiales.any(self.cumpleLaPrimeraCondicion())
	
	method hayMaterialRadiactivo(materiales) = materiales.any(self.cumpleLaSegundaCondicion())	

	override method cumpleLaPrimeraCondicion() = {material => material.gramosDeMetal()>200}
	
	override method cumpleLaSegundaCondicion() = {material => material.esRadiactivo()}

	override method efecto(materiales){
		rick.agregarMaterial(new Bateria(materiales))
		rick.companiero().perderEnergia(5)
	}
}

class ConstruirCircuito inherits Experimento{
	override method cumpleLosRequisito(materiales) = materiales.any(self.cumpleLaPrimeraCondicion())
	
	override method efecto(materiales){
		rick.agregarMaterial(new Circuito(materiales))
	}
	
	override method materialesParaRealizarlo(materiales, estrategia) = materiales.filter(self.cumpleLaPrimeraCondicion())
	
	override method cumpleLaPrimeraCondicion() = {material => material.conductividadElectrica() >= 5}
	
	override method cumpleLaSegundaCondicion() = {}
}

class ShockElectrico inherits Experimento{
	override method cumpleLosRequisito(materiales){
		return self.hayMaterialConductor(materiales) && self.hayMaterialGenerador(materiales)
	}
	
	method hayMaterialConductor(materiales) = materiales.any(self.cumpleLaPrimeraCondicion())
	
	method hayMaterialGenerador(materiales) = materiales.any(self.cumpleLaSegundaCondicion())
	
	override method cumpleLaSegundaCondicion() = {material=>material.conductividadElectrica() > 0}
	
	override method cumpleLaPrimeraCondicion() = {material=>material.energiaQueProduce() > 0}
	
	override method efecto(materiales){
		rick.companiero().aumentarEnergia(self.energiaDelPrimerElemento(materiales) * self.conductividadDelSegundoElemento(materiales))
	}
	
	method energiaDelPrimerElemento(materiales) = materiales.first().energiaQueProduce()

	method conductividadDelSegundoElemento(materiales) = materiales.last().conductividadElectrica()
}

	 
class Estrategia{
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