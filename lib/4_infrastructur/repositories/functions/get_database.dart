import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';

SupabaseQueryBuilder getReceiptDatabase(ReceiptTyp receiptTyp) {
  return switch (receiptTyp) {
    ReceiptTyp.offer => supabase.from('d_offers'),
    ReceiptTyp.appointment => supabase.from('d_appointments'),
    ReceiptTyp.deliveryNote => supabase.from('d_delivery_notes'),
    ReceiptTyp.invoice || ReceiptTyp.credit => supabase.from('d_invoices'),
  };
}
