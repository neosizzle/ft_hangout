
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../pages/home_page.dart';

class ContactPage extends StatefulWidget {
  final bool isEdit;
  final int? contactId;

  const ContactPage({
    super.key,
    required this.isEdit,
    this.contactId,
  });

  @override
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _notesController = TextEditingController();
  final _addressController = TextEditingController();
  final _auraController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;

  Map<String, dynamic> contact = {
    'id': null,
    'name': '',
    'mobile': '',
    'notes': null,
    'address': null,
    'aura': null,
    'created_at': null,
  };

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.contactId != null) {
      loadContact(widget.contactId!);
    }
  }

  Future<void> loadContact(int contactId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result =
          await DatabaseHelper.instance.getContactById(contactId);

      if (!mounted) return;

      if (result != null) {
        setState(() {
          contact = result;

          _nameController.text =
              result['name']?.toString() ?? '';

          _mobileController.text =
              result['mobile']?.toString() ?? '';

          _notesController.text =
              result['notes']?.toString() ?? '';

          _addressController.text =
              result['address']?.toString() ?? '';

          _auraController.text =
              result['aura']?.toString() ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Failed to load contact: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> saveContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final auraText = _auraController.text.trim();

    final Map<String, dynamic> data = {
      'name': _nameController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'notes': _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      'address': _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      'aura': auraText.isEmpty
          ? null
          : int.parse(auraText),
    };

    try {
      if (widget.isEdit) {
        data['id'] = widget.contactId;
        
        await DatabaseHelper.instance.updateContact(data);
      } else {
        await DatabaseHelper.instance.insertContact(data);
      }

      if (!mounted) return;

      _showMessage(
        widget.isEdit
            ? 'Contact updated successfully'
            : 'Contact created successfully',
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        _showMessage('Failed to save contact: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          alignLabelWithHint: maxLines > 1,
        ),
        validator: validator,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _notesController.dispose();
    _addressController.dispose();
    _auraController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Contact' : 'Add Contact',
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Name
                  _buildTextField(
                    label: 'Name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),

                  // Mobile
                  _buildTextField(
                    label: 'Mobile',
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Mobile is required';
                      }

                      if (!RegExp(r'^[0-9]+$')
                          .hasMatch(value.trim())) {
                        return 'Mobile must contain digits only';
                      }

                      return null;
                    },
                  ),

                  // Notes
                  _buildTextField(
                    label: 'Notes',
                    controller: _notesController,
                    maxLines: 3,
                  ),

                  // Address
                  _buildTextField(
                    label: 'Address',
                    controller: _addressController,
                    maxLines: 3,
                  ),

                  // Aura (INTEGER)
                  _buildTextField(
                    label: 'Aura',
                    controller: _auraController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return null;
                      }

                      if (int.tryParse(value.trim()) == null) {
                        return 'Aura must be a valid integer';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Cancel and Save buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSaving
                              ? null
                              : () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _isSaving ? null : saveContact,
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  widget.isEdit
                                      ? 'Update'
                                      : 'Save',
                                ),
                        ),
                      ),
                    ],
                  ),

                   if (widget.isEdit)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        int? contactId = widget.contactId;
                        if (contactId != null) await DatabaseHelper.instance.deleteContact(contactId);
                      
                        if (!mounted) return;

                        _showMessage('Contact deleted');
                         Navigator.pushReplacement(
                          this.context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text('Delete'),
                    ),
                ],
              ),
            ),
    );
  }
}
