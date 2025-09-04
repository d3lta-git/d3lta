// lib/screens/terms_screen.dart
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        backgroundColor: const Color(0xFF0A0A0F),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withValues(alpha: 0.9),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const HeaderSection(),
                const SizedBox(height: 30),
                const PreambleSection(),
                const SizedBox(height: 30),
                const Section1(),
                const SizedBox(height: 30),
                const Section2(),
                const SizedBox(height: 30),
                const Section3(),
                // Removed undefined sections (Section4 through Section13)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Header section
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Términos y Condiciones Generales de Servicios de Diseño',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7DF4E),
            shadows: [
              Shadow(
                color: Color(0xFF26AEFB),
                blurRadius: 10.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Fecha de Última Actualización: 24 de Junio del 2025.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFA0E9FF),
          ),
        ),
      ],
    );
  }
}

// Preamble section
class PreambleSection extends StatelessWidget {
  const PreambleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Preámbulo'),
          const SizedBox(height: 15),
          const Text(
            'Este documento establece los términos y condiciones (en adelante, los "Términos y Condiciones") que rigen la relación contractual entre el proveedor de los servicios de diseño (en adelante, "El Diseñador") y cualquier persona física o jurídica que contrate dichos servicios a través del sitio web (en adelante, "El Cliente"). La solicitud de un servicio a través de los canales dispuestos por El Diseñador, seguida de la confirmación de una Propuesta de Servicio, implica la aceptación plena y sin reservas de todos y cada uno de los términos aquí expuestos, constituyendo un contrato legalmente vinculante para ambas partes.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// Section 1: Acceptance and Contracting Parties
class Section1 extends StatelessWidget {
  const Section1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Sección 1: Aceptación y Partes Contratantes'),
          const SizedBox(height: 20),
          const SubSectionTitle(title: '1.1. Las Partes'),
          const SizedBox(height: 10),
          const Text(
            'El presente contrato se celebra entre:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          const BulletPoint(
            text: 'El Diseñador: Un profesional independiente que opera bajo el régimen de Monotributo en la República Argentina, con capacidad para emitir las facturas correspondientes por los servicios prestados. Se deja constancia de que El Diseñador actúa a título personal y no como una sociedad comercial formalmente registrada o constituida.',
          ),
          const SizedBox(height: 10),
          const BulletPoint(
            text: 'El Cliente: La persona física o jurídica que solicita y contrata los servicios de diseño ofrecidos por El Diseñador.',
          ),
          const SizedBox(height: 20),
          const SubSectionTitle(title: '1.2. Aceptación'),
          const SizedBox(height: 10),
          const Text(
            'El proceso de contratación se inicia cuando El Cliente completa y envía el formulario de pedido disponible en el sitio web del Diseñador. El contrato se considerará perfeccionado y legalmente vinculante en el momento en que El Cliente acepte expresamente por escrito (por ejemplo, vía correo electrónico) la Propuesta de Servicio final enviada por El Diseñador y se verifique la acreditación del pago inicial correspondiente. Dicha aceptación constituye una manifestación de voluntad inequívoca y la adhesión total a estos Términos y Condiciones.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const SubSectionTitle(title: '1.3. Capacidad Legal'),
          const SizedBox(height: 10),
          const Text(
            'El Cliente declara, bajo juramento, que posee la plena capacidad legal para contratar, obligarse y cumplir con los términos del presente acuerdo, de conformidad con la legislación vigente en la República Argentina. En caso de actuar en representación de una persona jurídica, declara contar con las facultades suficientes para representarla y obligarla contractualmente.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// Section 2: Key Definitions
class Section2 extends StatelessWidget {
  const Section2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Sección 2: Definiciones Clave'),
          const SizedBox(height: 15),
          const Text(
            'A los efectos del presente contrato, los siguientes términos tendrán el significado que se les atribuye a continuación:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 15),
          const DefinitionItem(
            term: '2.1. Propuesta de Servicio:',
            definition: 'El documento o comunicación formal, típicamente un correo electrónico, enviado por El Diseñador al Cliente tras la recepción y análisis del formulario de pedido. Este documento detallará el alcance final de los trabajos, las especificaciones técnicas, el cronograma estimado de entregas y el presupuesto total del Proyecto. La aceptación de esta propuesta por parte del Cliente es un requisito indispensable para el inicio de cualquier trabajo.',
          ),
          const SizedBox(height: 10),
          const DefinitionItem(
            term: '2.2. Proyecto:',
            definition: 'La totalidad de los trabajos de creación, diseño y desarrollo a ser realizados por El Diseñador, conforme a lo especificado y acordado en la Propuesta de Servicio aceptada por El Cliente.',
          ),
          const SizedBox(height: 10),
          const DefinitionItem(
            term: '2.3. Entregable:',
            definition: 'Cada uno de los archivos, diseños, bocetos, maquetas o piezas de trabajo producidos por El Diseñador en las distintas fases del Proyecto y presentados al Cliente para su revisión, feedback o aprobación.',
          ),
          const SizedBox(height: 10),
          const DefinitionItem(
            term: '2.4. Entregable Final:',
            definition: 'El conjunto de archivos digitales en alta resolución, libres de marcas de agua y en los formatos especificados, que constituyen el resultado definitivo y completo del Proyecto, los cuales son entregados al Cliente únicamente tras la cancelación total de los honorarios pactados.',
          ),
          const SizedBox(height: 10),
          const DefinitionItem(
            term: '2.5. Material del Cliente:',
            definition: 'Toda la información, textos, imágenes, logotipos, directrices de marca, archivos de diseño preexistentes y cualquier otro material o activo proporcionado por El Cliente a El Diseñador con el fin de ser utilizado en la ejecución del Proyecto.',
          ),
          const SizedBox(height: 10),
          const DefinitionItem(
            term: '2.6. Día Hábil:',
            definition: 'Se entenderá por Día Hábil cualquier día de lunes a viernes que no sea feriado nacional o día no laborable decretado por la autoridad competente en la República Argentina. El horario de trabajo para el cómputo de plazos será de 9:00 a 18:00 horas (hora local de Argentina).',
          ),
          const SizedBox(height: 10),
          const DefinitionItem(
            term: '2.7. Revisión:',
            definition: 'Cada una de las instancias en las que El Cliente proporciona a El Diseñador un conjunto de comentarios, feedback o solicitudes de modificación sobre un Entregable presentado. Cada ronda de revisión se computa como una unidad, independientemente del número de cambios solicitados dentro de esa misma comunicación.',
          ),
        ],
      ),
    );
  }
}

// Section 3: Object and Scope of Services
class Section3 extends StatelessWidget {
  const Section3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Sección 3: Objeto y Alcance de los Servicios'),
          const SizedBox(height: 20),
          const SubSectionTitle(title: '3.1. Objeto'),
          const SizedBox(height: 10),
          const Text(
            'El objeto del presente contrato es la prestación de servicios profesionales de diseño gráfico por parte de El Diseñador, los cuales pueden incluir, de manera no taxativa, la creación de códigos QR artísticos, diseño de identidad visual, desarrollo de piezas gráficas para medios digitales o impresos, y otros servicios asociados que se detallan en el sitio web y se especifican para cada caso particular en la Propuesta de Servicio.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const SubSectionTitle(title: '3.2. Niveles de Diseño y Revisiones'),
          const SizedBox(height: 10),
          const Text(
            'El alcance del trabajo creativo, así como el número de rondas de revisión incluidas en el precio base del Proyecto, están directamente determinados por el "Nivel de Diseño" que El Cliente seleccione al momento de la contratación. La formalización de estos niveles previene la ampliación descontrolada del alcance del proyecto, gestionando las expectativas del cliente y eliminando ambigüedades sobre el proceso de feedback. La siguiente tabla detalla la correspondencia entre el nivel de servicio y las revisiones incluidas:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.white.withValues(alpha: 0.1)),
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: const Color(0xFF26AEFB).withValues(alpha: 0.15),
                  ),
                  children: [
                    const TableCellHeader(text: 'Nivel de Diseño'),
                    const TableCellHeader(text: 'Revisiones Incluidas'),
                    const TableCellHeader(text: 'Descripción Breve'),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCellContent(text: 'Básico'),
                    const TableCellContent(text: '1 (una)'),
                    const TableCellContent(text: 'Integración de logo, patrón estándar y hasta 3 colores de marca.'),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCellContent(text: 'Estándar'),
                    const TableCellContent(text: '2 (dos)'),
                    const TableCellContent(text: 'Diseño creativo que integra el logo y hasta 5 colores de marca.'),
                  ],
                ),
                TableRow(
                  children: [
                    const TableCellContent(text: 'Premium'),
                    const TableCellContent(text: '4 (cuatro)'),
                    const TableCellContent(text: 'Concepto artístico a medida, ilustraciones y hasta 7 colores de marca.'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SubSectionTitle(title: '3.3. Revisiones Adicionales'),
          const SizedBox(height: 10),
          const Text(
            'Cualquier solicitud de revisión que exceda el número estipulado en la tabla anterior para el Nivel de Diseño contratado será considerada una modificación al alcance original del Proyecto. Dicha revisión adicional estará sujeta a una cotización y facturación por separado. El Diseñador no procederá con la ejecución de revisiones adicionales hasta no contar con la aprobación expresa y por escrito de la cotización correspondiente por parte del Cliente.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// Section title widget
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(), // Using toUpperCase() instead of textTransform
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.05,
      ),
    );
  }
}

// Sub-section title widget
class SubSectionTitle extends StatelessWidget {
  final String title;

  const SubSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFFA0E9FF),
      ),
    );
  }
}

// Bullet point widget
class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            color: Color(0xFF26AEFB),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

// Definition item widget
class DefinitionItem extends StatelessWidget {
  final String term;
  final String definition;

  const DefinitionItem({super.key, required this.term, required this.definition});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFF26AEFB),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              term.substring(0, term.indexOf('.')),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                term,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7DF4E),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                definition,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Table cell header widget
class TableCellHeader extends StatelessWidget {
  final String text;

  const TableCellHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFFA0E9FF),
          letterSpacing: 0.05,
        ),
      ),
    );
  }
}

// Table cell content widget
class TableCellContent extends StatelessWidget {
  final String text;

  const TableCellContent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}