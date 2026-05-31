import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/command.dart';
import '../../common/theme/app_theme.dart';
import '../../domain/entity/transaction_entity.dart';

/// Formulário para adicionar transações de receita ou despesa.
///
/// Re-estilizado com a paleta PicPay — inputs com bordas suaves,
/// botão verde arredondado, animações de loading.
class TransactionForm extends StatefulWidget {
  /// Comando para submeter a transação
  final Command1<void, Failure, TransactionEntity> submitCommand;

  /// Tipo de transação (receita ou despesa)
  final TransactionType type;

  /// Cor do tema para o formulário
  final Color color;

  const TransactionForm({
    super.key,
    required this.type,
    required this.color,
    required this.submitCommand,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.color,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      final newTransaction = TransactionEntity(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        type: widget.type,
      );

      await widget.submitCommand.execute(newTransaction);

      if (!mounted) return;

      if (widget.submitCommand.resultSignal.value?.isFailure ?? false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao adicionar ${widget.type.nameSingular}: '
              '${widget.submitCommand.resultSignal.value?.failureValueOrNull ?? 'Erro desconhecido'}',
            ),
            backgroundColor: AppColors.expense,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
        return;
      }

      _titleController.clear();
      _amountController.clear();
      setState(() => _selectedDate = DateTime.now());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.type.nameSingular} adicionada com sucesso!'),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Campo: Descrição ───
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                prefixIcon: Icon(Icons.description_rounded, color: widget.color),
              ),
              style: GoogleFonts.montserrat(fontSize: 14),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe uma descrição';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ─── Campo: Valor ───
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Valor',
                prefixIcon: Icon(Icons.attach_money_rounded, color: widget.color),
              ),
              style: GoogleFonts.montserrat(fontSize: 14),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe um valor';
                if (double.tryParse(value) == null) {
                  return 'Digite um número válido';
                }
                if (double.parse(value) <= 0) {
                  return 'O valor deve ser maior que zero';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ─── Seletor de Data ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      color: widget.color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      'Alterar',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ─── Botão de Envio ───
            Watch((context) {
              final isRunning = widget.submitCommand.runningSignal.value;

              return SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isRunning ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isRunning
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Adicionar ${widget.type.nameSingular}',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
