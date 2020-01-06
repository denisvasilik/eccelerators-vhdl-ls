/*
 * generated by Xtext 2.19.0
 */
package com.eccelerators.plugins.vhdl.formatting2

import com.eccelerators.plugins.vhdl.services.VhdlGrammarAccess
import com.eccelerators.plugins.vhdl.vhdl.DesignUnit
import com.eccelerators.plugins.vhdl.vhdl.Model
import com.google.inject.Inject
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import com.eccelerators.plugins.vhdl.vhdl.EntityDeclaration
import com.google.common.base.Strings
import com.eccelerators.plugins.vhdl.vhdl.PortClause
import com.eccelerators.plugins.vhdl.vhdl.InterfaceList
import com.eccelerators.plugins.vhdl.vhdl.SignalInterfaceDeclaration
import com.eccelerators.plugins.vhdl.vhdl.ConstantInterfaceDeclaration
import com.eccelerators.plugins.vhdl.vhdl.DeclaredConstantIdentifiers
import com.eccelerators.plugins.vhdl.vhdl.DeclaredSignalIdentifiers
import com.eccelerators.plugins.vhdl.vhdl.VhdlPackage
import com.eccelerators.plugins.vhdl.vhdl.GenericClause
import com.eccelerators.plugins.vhdl.vhdl.ContextItem
import com.eccelerators.plugins.vhdl.vhdl.LibraryClause
import com.eccelerators.plugins.vhdl.vhdl.UseClause
import com.eccelerators.plugins.vhdl.vhdl.PackageReference
import com.eccelerators.plugins.vhdl.vhdl.LibraryUnit
import com.eccelerators.plugins.vhdl.vhdl.ArchitectureDeclaration
import com.eccelerators.plugins.vhdl.vhdl.ParameterizedTypeIdentifierReference
import com.eccelerators.plugins.vhdl.vhdl.TypeIdentifierOuterRangeConstraint
import com.eccelerators.plugins.vhdl.vhdl.Mode
import com.eccelerators.plugins.vhdl.vhdl.ExpressionDeclaration
import com.eccelerators.plugins.vhdl.vhdl.SignalDeclaration
import com.eccelerators.plugins.vhdl.vhdl.ConstantDeclaration
import com.eccelerators.plugins.vhdl.vhdl.ComponentDeclaration
import com.eccelerators.plugins.vhdl.vhdl.ConditionalSignalAssignmentSatement
import com.eccelerators.plugins.vhdl.vhdl.InnerRangeConstraint
import com.eccelerators.plugins.vhdl.vhdl.InnerExpressionOrInnerAggregate
import com.eccelerators.plugins.vhdl.vhdl.InnerHead
import com.eccelerators.plugins.vhdl.vhdl.ProcessStatement
import com.eccelerators.plugins.vhdl.vhdl.GenerateStatement
import com.eccelerators.plugins.vhdl.vhdl.ComponentInstantiationStatement

class VhdlFormatter extends AbstractFormatter2 {
 
	@Inject extension VhdlGrammarAccess

	int indentation_level = 0;

	def dispatch void format(Model model, extension IFormattableDocument document) {
		for (designUnit : model.designUnits) {
			designUnit.format
		}
	}
 
	def dispatch void format(DesignUnit designUnit, extension IFormattableDocument document) {
		val libraryClauses = designUnit.contextClause.filter[contextItem|contextItem instanceof LibraryClause]
		val useClauses = designUnit.contextClause.filter[contextItem|contextItem instanceof UseClause]

		formatFirst((libraryClauses.head as LibraryClause), document)
		libraryClauses.tail.forEach[contextItem|(contextItem as LibraryClause).format]
		useClauses.forEach[contextItem|(contextItem as UseClause).format]
		designUnit.libraryUnit.format
	}

	def dispatch void format(ContextItem contextItem, extension IFormattableDocument document) {
		if (contextItem instanceof LibraryClause) {
			(contextItem as LibraryClause).format
		}
		if (contextItem instanceof UseClause) {
			(contextItem as UseClause).format
		}
	}

	def void formatFirst(LibraryClause libraryClause, extension IFormattableDocument document) {
		libraryClause.regionFor.keyword("library").prepend[noSpace]
		libraryClause.regionFor.keyword("library").append[oneSpace]
		libraryClause.regionFor.keyword(",").prepend[noSpace]
		libraryClause.regionFor.keyword(",").append[oneSpace]
		libraryClause.regionFor.keyword(";").prepend[noSpace]
		libraryClause.regionFor.keyword(";").append[newLine]
	}

	def dispatch void format(LibraryClause libraryClause, extension IFormattableDocument document) {
		libraryClause.regionFor.keyword("library").prepend[highPriority(); setNewLines(2)]
		libraryClause.regionFor.keyword("library").append[oneSpace]
		libraryClause.regionFor.keyword(",").prepend[noSpace]
		libraryClause.regionFor.keyword(",").append[oneSpace]
		libraryClause.regionFor.keyword(";").prepend[noSpace]
		libraryClause.regionFor.keyword(";").append[newLine]
	}

	def dispatch void format(UseClause useClause, extension IFormattableDocument document) {
		useClause.regionFor.keyword("use").prepend[noSpace]
		useClause.regionFor.keyword("use").append[oneSpace]

		if (useClause.importedNamespace !== null) {
			useClause.importedNamespace.format
		}

		useClause.regionFor.keyword(",").prepend[noSpace]
		useClause.regionFor.keyword(",").append[oneSpace]

		for (importedNamespace : useClause.importedNamespaceList) {
			importedNamespace.format
		}

		useClause.regionFor.keyword(";").prepend[noSpace]
		useClause.regionFor.keyword(";").append[newLine]
	}

	def dispatch void format(PackageReference packageReference, extension IFormattableDocument document) {
		packageReference.regionFor.keyword(".").prepend[noSpace]
		packageReference.regionFor.keyword(".").append[noSpace]
	}

	def dispatch void format(EntityDeclaration entityDeclaration, extension IFormattableDocument document) {
		entityDeclaration.regionFor.keyword("entity").prepend[highPriority(); setNewLines(2);]
		entityDeclaration.regionFor.keyword("entity").append[oneSpace]
		entityDeclaration.regionFor.keyword("is").prepend[oneSpace]

		if (entityDeclaration.genericClause !== null) {
			entityDeclaration.genericClause.format
		}

		if (entityDeclaration.portClause !== null) {
			entityDeclaration.portClause.format
		}

		entityDeclaration.regionFor.keyword("end").prepend[newLine]
		entityDeclaration.regionFor.keyword("end").append[oneSpace]

		val entities = entityDeclaration.regionFor.keywords("entity")
		if (entities.size() > 1) {
			entities.get(1).append[oneSpace]
		}

		entityDeclaration.regionFor.keyword(";").prepend[highPriority(); noSpace]
		entityDeclaration.regionFor.keyword(";").append[setNewLines(2)]
	}

	def dispatch void format(GenericClause genericClause, extension IFormattableDocument document) {
		genericClause.regionFor.keyword("generic").prepend [
			highPriority();
			space = "\n  " + Strings.repeat(" ", indentation_level)
		]
		genericClause.regionFor.keyword("(").prepend[oneSpace]
		genericClause.regionFor.keyword("(").append[space = "\n    "]

		if (genericClause.interfaceList !== null) {
			genericClause.interfaceList.format
		}

		genericClause.regionFor.keyword(")").prepend[space = "\n  "]
		genericClause.regionFor.keyword(";").prepend[noSpace]
	}

	def dispatch void format(PortClause portClause, extension IFormattableDocument document) {
		portClause.regionFor.keyword("port").prepend [
			highPriority();
			space = "\n  " + Strings.repeat(" ", indentation_level)
		]
		portClause.regionFor.keyword("(").prepend[oneSpace]
		portClause.regionFor.keyword("(").append[space = "\n    " + Strings.repeat(" ", indentation_level)]

		if (portClause.interfaceList !== null) {
			portClause.interfaceList.format
		}

		portClause.regionFor.keyword(")").prepend [
			highPriority();
			space = "\n  " + Strings.repeat(" ", indentation_level)
		]
		portClause.regionFor.keyword(";").append[noSpace]
	}

	def dispatch void format(InterfaceList interfaceList, extension IFormattableDocument document) {
		interfaceList.regionFor.keywords(";").forEach [ keyword |
			keyword.prepend[noSpace]
			keyword.append[space = "\n    " + Strings.repeat(" ", indentation_level)]
		]

		interfaceList.head.format

		for (interfaceDeclaration : interfaceList.tail) {
			interfaceDeclaration.format
		}
	}

	def dispatch void format(SignalInterfaceDeclaration signalInterfaceDeclaration,
		extension IFormattableDocument document) {
		signalInterfaceDeclaration.regionFor.keyword("signal").append[oneSpace]

		signalInterfaceDeclaration.identifiers.format
		signalInterfaceDeclaration.type.format
		signalInterfaceDeclaration.mode.format
		signalInterfaceDeclaration.expression.format

		signalInterfaceDeclaration.regionFor.keyword(":").prepend[oneSpace]
		signalInterfaceDeclaration.regionFor.keyword(":").append[oneSpace]
		signalInterfaceDeclaration.regionFor.keyword("bus").prepend[oneSpace]
		signalInterfaceDeclaration.regionFor.keyword("bus").append[oneSpace]
		signalInterfaceDeclaration.regionFor.keyword(":=").prepend[oneSpace]
		signalInterfaceDeclaration.regionFor.keyword(":=").append[oneSpace]
	}

	def dispatch void format(Mode mode, extension IFormattableDocument document) {
		mode.regionFor.keyword("in").surround[oneSpace]
		mode.regionFor.keyword("out").surround[oneSpace]
		mode.regionFor.keyword("inout").surround[oneSpace]
		mode.regionFor.keyword("buffer").surround[oneSpace]
		mode.regionFor.keyword("linkage").surround[oneSpace]
	}

	def dispatch void format(ParameterizedTypeIdentifierReference parameterizedTypeIdentifierReference,
		extension IFormattableDocument document) {
		parameterizedTypeIdentifierReference.constraint.format
	}
 
	def dispatch void format(TypeIdentifierOuterRangeConstraint typeIdentifierOuterRangeConstraint,
		extension IFormattableDocument document) {
		typeIdentifierOuterRangeConstraint.regionFor.keyword("(").prepend[oneSpace]
		typeIdentifierOuterRangeConstraint.regionFor.keyword("(").append[noSpace]
		typeIdentifierOuterRangeConstraint.regionFor.keyword(")").prepend[noSpace]
		typeIdentifierOuterRangeConstraint.regionFor.keyword(")").append[oneSpace]
		typeIdentifierOuterRangeConstraint.regionFor.keyword("to").surround[oneSpace]
		typeIdentifierOuterRangeConstraint.regionFor.keyword("downto").surround[oneSpace]
	}

	def dispatch void format(ConstantInterfaceDeclaration signalInterfaceDeclaration,
		extension IFormattableDocument document) {
		signalInterfaceDeclaration.identifiers.head.format
		for (identifier : signalInterfaceDeclaration.identifiers.tail) {
			identifier.format
		}
	}

	def dispatch void format(DeclaredSignalIdentifiers declaredSignalIdentifiers,
		extension IFormattableDocument document) {
		declaredSignalIdentifiers.regionFor.keywords(",").forEach [ keyword |
			keyword.prepend[noSpace]
			keyword.append[oneSpace]
		]
	}

	def dispatch void format(DeclaredConstantIdentifiers declaredConstantIdentifiers,
		extension IFormattableDocument document) {
		declaredConstantIdentifiers.regionFor.keywords(",").forEach [ keyword |
			keyword.prepend[noSpace]
			keyword.append[oneSpace]
		]
	}

	def dispatch void format(ArchitectureDeclaration architectureDeclaration, extension IFormattableDocument document) {
		architectureDeclaration.regionFor.keyword("architecture").prepend[highPriority(); setNewLines(2);]
		architectureDeclaration.regionFor.keyword("architecture").append[oneSpace]
		architectureDeclaration.regionFor.keyword("of").surround[oneSpace]
		architectureDeclaration.regionFor.keyword("is").prepend[oneSpace]
		architectureDeclaration.regionFor.keyword("is").append[highPriority(); space = "\n\n    "]

		architectureDeclaration.blocks.forEach[block|block.format]

		architectureDeclaration.regionFor.keyword("begin").prepend[highPriority(); setNewLines(2);]
		architectureDeclaration.regionFor.keyword("begin").append[highPriority(); space = "\n\n    "]

		architectureDeclaration.statements.forEach[statement|statement.format]

		architectureDeclaration.regionFor.keyword("end").prepend[highPriority(); setNewLines(2);]
		architectureDeclaration.regionFor.keyword("end").append[oneSpace]

		val architectures = architectureDeclaration.regionFor.keywords("architecture")
		if (architectures.size() > 1) {
			architectures.get(1).append[oneSpace]
		}

		architectureDeclaration.regionFor.keyword(";").prepend[highPriority(); noSpace]
		architectureDeclaration.regionFor.keyword(";").append[noSpace]
	}

	def dispatch void format(SignalDeclaration signalDeclaration, extension IFormattableDocument document) {
		signalDeclaration.regionFor.keyword("signal").prepend[space = "    "]
		signalDeclaration.regionFor.keyword("signal").append[oneSpace]
		signalDeclaration.identifiers.format
		signalDeclaration.regionFor.keyword(":").prepend[oneSpace]
		signalDeclaration.regionFor.keyword(":").append[oneSpace]
		signalDeclaration.type.format
		signalDeclaration.kind.format
		signalDeclaration.regionFor.keyword(":=").prepend[oneSpace]
		signalDeclaration.regionFor.keyword(":=").append[oneSpace]
		signalDeclaration.expression.format
		signalDeclaration.regionFor.keyword(";").prepend[noSpace]
		signalDeclaration.regionFor.keyword(";").append[noSpace]
	}

	def dispatch void format(ConstantDeclaration constantDeclaration, extension IFormattableDocument document) {
		constantDeclaration.regionFor.keyword("constant").prepend[space = "    "]
		constantDeclaration.regionFor.keyword("constant").append[oneSpace]
		constantDeclaration.identifiers.format
		constantDeclaration.regionFor.keyword(":").prepend[oneSpace]
		constantDeclaration.regionFor.keyword(":").append[oneSpace]
		constantDeclaration.type.format
		constantDeclaration.regionFor.keyword(":=").prepend[oneSpace]
		constantDeclaration.regionFor.keyword(":=").append[oneSpace]
		constantDeclaration.expression.format
		constantDeclaration.regionFor.keyword(";").prepend[noSpace]
		constantDeclaration.regionFor.keyword(";").append[noSpace]
	}

	def dispatch void format(ComponentDeclaration componentDeclaration, extension IFormattableDocument document) {
		componentDeclaration.regionFor.keyword("component").prepend[highPriority(); space = "\n\n    "]
		componentDeclaration.regionFor.keyword("component").append[oneSpace]
		componentDeclaration.regionFor.keyword("is").prepend[oneSpace]
		componentDeclaration.regionFor.keyword("is").append[noSpace]

		indentation_level = 4;

		componentDeclaration.genericClause.format
		componentDeclaration.portClause.format

		indentation_level = 0;

		componentDeclaration.regionFor.keyword("end").prepend[highPriority(); space = "\n    "]
		componentDeclaration.regionFor.keyword("end").append[oneSpace]

		val components = componentDeclaration.regionFor.keywords("component")
		if (components.size() > 1) {
			components.get(1).append[oneSpace]
		}

		componentDeclaration.regionFor.keyword(";").prepend[highPriority(); noSpace]
		componentDeclaration.regionFor.keyword(";").append[noSpace]
	}

	def dispatch void format(ConditionalSignalAssignmentSatement conditionalSignalAssignmentSatement,
		extension IFormattableDocument document) {
		conditionalSignalAssignmentSatement.allSemanticRegions.take(1).forEach[region|region.prepend[space = "\n    "]]

		conditionalSignalAssignmentSatement.regionFor.keyword(":").prepend[oneSpace]
		conditionalSignalAssignmentSatement.regionFor.keyword(":").append[oneSpace]
		conditionalSignalAssignmentSatement.regionFor.keyword("<=").prepend[oneSpace]
		conditionalSignalAssignmentSatement.regionFor.keyword("<=").append[oneSpace]

		conditionalSignalAssignmentSatement.conditionalExpression.format

		conditionalSignalAssignmentSatement.regionFor.keyword("when").prepend[oneSpace]
		conditionalSignalAssignmentSatement.regionFor.keyword("when").append[oneSpace]

		conditionalSignalAssignmentSatement.whenExpressions.format

		conditionalSignalAssignmentSatement.regionFor.keyword("else").prepend[oneSpace]
		conditionalSignalAssignmentSatement.regionFor.keyword("else").append[oneSpace]

		conditionalSignalAssignmentSatement.elseExpressions.format

		conditionalSignalAssignmentSatement.regionFor.keyword(";").prepend[highPriority(); noSpace]
		conditionalSignalAssignmentSatement.regionFor.keyword(";").append[lowPriority(); noSpace]
	}

	def dispatch void format(ProcessStatement processStatement, extension IFormattableDocument document) {
		processStatement.allSemanticRegions.take(1).forEach[region|region.prepend[highPriority(); space = "\n\n    "]]
		processStatement.regionFor.keyword(":").prepend[oneSpace]
		processStatement.regionFor.keyword(":").append[oneSpace]
		processStatement.regionFor.keyword("process").append[space = "\n        "]
		processStatement.regionFor.keyword("is").prepend[highPriority(); oneSpace]
		processStatement.regionFor.keyword("is").append[space = "\n        "]

		processStatement.items.forEach[item|item.format]

		processStatement.regionFor.keyword("begin").prepend[highPriority(); space = "\n    "]
		processStatement.regionFor.keyword("begin").append[highPriority(); space = "\n        "]

		processStatement.statements.forEach[statement|statement.format]

		processStatement.regionFor.keyword("end").prepend[highPriority(); space = "\n    "]
		processStatement.regionFor.keyword("end").append[oneSpace]

		val components = processStatement.regionFor.keywords("process")
		if (components.size() > 1) {
			components.get(1).append[oneSpace]
		}

		processStatement.regionFor.keyword(";").prepend[highPriority(); noSpace]
		processStatement.regionFor.keyword(";").append[noSpace]
	}

	def dispatch void format(ComponentInstantiationStatement componentInstantiationStatement,
		extension IFormattableDocument document) {
		componentInstantiationStatement.allSemanticRegions.take(1).forEach[region|region.prepend[space = "\n\n    "]]
		componentInstantiationStatement.regionFor.keyword(":").prepend[oneSpace]
		componentInstantiationStatement.regionFor.keyword(":").append[oneSpace]
		componentInstantiationStatement.genericMapAspect.format
		componentInstantiationStatement.portMapAspect.format
		componentInstantiationStatement.regionFor.keyword(";").prepend[highPriority(); noSpace]
		componentInstantiationStatement.regionFor.keyword(";").append[noSpace]
	}

	def dispatch void format(GenerateStatement generateStatement, extension IFormattableDocument document) {
		generateStatement.allSemanticRegions.take(1).forEach[region|region.prepend[space = "\n\n    "]]
		generateStatement.regionFor.keyword(":").prepend[oneSpace]
		generateStatement.regionFor.keyword(":").append[oneSpace]
		generateStatement.regionFor.keyword("generate").prepend[oneSpace]
		generateStatement.regionFor.keyword("generate").append[highPriority(); space = "\n        "]
		
		generateStatement.blocks.forEach[block|block.format]
		
		generateStatement.regionFor.keyword("begin").prepend[highPriority(); space = "\n    "]
		generateStatement.regionFor.keyword("begin").append[highPriority(); space = "\n        "]
		
		generateStatement.concurrentStatements.forEach[concurrentStatement|concurrentStatement.format]
		
		generateStatement.regionFor.keyword("end").prepend[highPriority(); space = "\n    "]
		generateStatement.regionFor.keyword("end").append[oneSpace]

		val components = generateStatement.regionFor.keywords("generate")
		if (components.size() > 1) {
			components.get(1).append[oneSpace]
		}

		generateStatement.regionFor.keyword(";").prepend[highPriority(); noSpace]
		generateStatement.regionFor.keyword(";").append[noSpace]
	}

	def dispatch void format(ExpressionDeclaration expressionDeclaration, extension IFormattableDocument document) {
		expressionDeclaration.regionFor.keyword("nand").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("nand").append[oneSpace]
		expressionDeclaration.regionFor.keyword("nor").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("nor").append[oneSpace]
		expressionDeclaration.regionFor.keyword("and").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("and").append[oneSpace]
		expressionDeclaration.regionFor.keyword("or").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("or").append[oneSpace]
		expressionDeclaration.regionFor.keyword("xor").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("xor").append[oneSpace]
		expressionDeclaration.regionFor.keyword("xnor").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("xnor").append[oneSpace]
		expressionDeclaration.regionFor.keyword("/=").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("/=").append[oneSpace]
		expressionDeclaration.regionFor.keyword("<").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("<").append[oneSpace]
		expressionDeclaration.regionFor.keyword(">").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword(">").append[oneSpace]
		expressionDeclaration.regionFor.keyword(">=").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword(">=").append[oneSpace]
		expressionDeclaration.regionFor.keyword("=").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("=").append[oneSpace]
		expressionDeclaration.regionFor.keyword("<=").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("<=").append[oneSpace]
		expressionDeclaration.regionFor.keyword("sll").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("sll").append[oneSpace]
		expressionDeclaration.regionFor.keyword("srl").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("srl").append[oneSpace]
		expressionDeclaration.regionFor.keyword("sla").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("sla").append[oneSpace]
		expressionDeclaration.regionFor.keyword("sra").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("sra").append[oneSpace]
		expressionDeclaration.regionFor.keyword("rol").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("rol").append[oneSpace]
		expressionDeclaration.regionFor.keyword("ror").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("ror").append[oneSpace]
		expressionDeclaration.regionFor.keyword("+").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("+").append[oneSpace]
		expressionDeclaration.regionFor.keyword("-").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("-").append[oneSpace]
		expressionDeclaration.regionFor.keyword("&").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("&").append[oneSpace]
		expressionDeclaration.regionFor.keyword("*").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("*").append[oneSpace]
		expressionDeclaration.regionFor.keyword("/").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("/").append[oneSpace]
		expressionDeclaration.regionFor.keyword("mod").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("mod").append[oneSpace]
		expressionDeclaration.regionFor.keyword("rem").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("rem").append[oneSpace]
		expressionDeclaration.regionFor.keyword("abs").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("abs").append[oneSpace]
		expressionDeclaration.regionFor.keyword("not").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("not").append[oneSpace]
		expressionDeclaration.regionFor.keyword("(").prepend[oneSpace]
		expressionDeclaration.regionFor.keyword("(").append[noSpace]
		expressionDeclaration.regionFor.keyword(")").prepend[noSpace]
		expressionDeclaration.regionFor.keyword(")").append[oneSpace]
		expressionDeclaration.range.format
		expressionDeclaration.left.format
		expressionDeclaration.right.format
		expressionDeclaration.inner.format
	}

	def dispatch void format(InnerExpressionOrInnerAggregate innerExpressionOrInnerAggregate,
		extension IFormattableDocument document) {
		innerExpressionOrInnerAggregate.innerHead.format
	}

	def dispatch void format(InnerHead innerHead, extension IFormattableDocument document) {
		innerHead.expr.format
	}

	def dispatch void format(InnerRangeConstraint innerRangeConstraint, extension IFormattableDocument document) {
		innerRangeConstraint.regionFor.keyword("to").prepend[oneSpace]
		innerRangeConstraint.regionFor.keyword("to").append[oneSpace]
		innerRangeConstraint.regionFor.keyword("downto").prepend[oneSpace]
		innerRangeConstraint.regionFor.keyword("downto").append[oneSpace]
		innerRangeConstraint.first.format
		innerRangeConstraint.second.format
	}
}