import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';

SupabaseQueryBuilder getReceiptDatabase(ReceiptType receiptTyp) {
  return switch (receiptTyp) {
    ReceiptType.offer => supabase.from('d_offers'),
    ReceiptType.appointment => supabase.from('d_appointments'),
    ReceiptType.deliveryNote => supabase.from('d_delivery_notes'),
    ReceiptType.invoice || ReceiptType.credit => supabase.from('d_invoices'),
  };
}
