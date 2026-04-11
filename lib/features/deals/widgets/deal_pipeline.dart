import 'package:flutter/material.dart';
import '../../../core/supabase/supabase_client.dart';
import '../models/deal_models.dart';

class DealPipeline extends StatefulWidget {
  const DealPipeline({super.key});

  @override
  State<DealPipeline> createState() => _DealPipelineState();
}

class _DealPipelineState extends State<DealPipeline> {
  List<Deal> _deals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeals();
  }

  Future<void> _fetchDeals() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await supabase
          .from('deals')
          .select()
          .eq('user_id', user.id)
          .order('created_at');

      setState(() {
        _deals = response.map((e) => Deal.fromMap(e)).toList();
      });
    } catch (e) {
      debugPrint("Error fetching deals: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateDealStatus(Deal deal, String newStatus) async {
    await supabase.from('deals').update({'status': newStatus}).eq('id', deal.id);
    _fetchDeals(); // Refresh the list
  }

  void _showNewDealDialog() {
    final nameController = TextEditingController();
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Deal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Client Name")),
            TextField(controller: valueController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Estimated Value (\$)")),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final user = supabase.auth.currentUser;
              await supabase.from('deals').insert({
                'user_id': user!.id,
                'client_name': nameController.text,
                'value': double.tryParse(valueController.text) ?? 0,
                'status': 'Lead',
              });
              if (mounted) {
                Navigator.pop(context);
                _fetchDeals();
              }
            },
            child: const Text("Create"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPipelineColumn("Lead", _deals.where((d) => d.status == 'Lead').toList(), "Negotiation"),
            _buildPipelineColumn("Negotiation", _deals.where((d) => d.status == 'Negotiation').toList(), "Contract"),
            _buildPipelineColumn("Contract", _deals.where((d) => d.status == 'Contract').toList(), "Closed"),
            _buildPipelineColumn("Closed", _deals.where((d) => d.status == 'Closed').toList(), null),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewDealDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPipelineColumn(String title, List<Deal> dealsInColumn, String? nextStage) {
    return Container(
      width: 280,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("$title (${dealsInColumn.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...dealsInColumn.map((deal) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deal.clientName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("\$${deal.value.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green)),
                  if (nextStage != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _updateDealStatus(deal, nextStage),
                        child: Text("Move to $nextStage"),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}