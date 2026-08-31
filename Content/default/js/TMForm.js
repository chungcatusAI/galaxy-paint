/* Config validation */
ko.validation.configure({
    registerExtenders: true,
    messagesOnModified: true,
    insertMessages: true,
    parseInputAttributes: true,
    messageTemplate: null,
    decorateElement: true,
    errorClass: "error",
    errorMessageClass: "error-desc"
});

var viewModel = new function () {
    // About you
    this.Fullname = ko.observable().extend({minLength: 5, maxLength: 50, required: { message: 'Tên liên hệ là bắt buộc' } });
    this.Email = ko.observable().extend({ required: { message: 'E-mail là bắt buộc' } }).extend({
        pattern: {
            message: "Xin hãy nhập e-mail hợp lệ",
            params: /^(([a-zA-Z0-9])+([a-zA-Z0-9_\.\-])+([a-zA-Z0-9]))+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
        }
    });
    this.Phone = ko.observable();
    this.Message = ko.observable().extend({minLength: 50, maxLength: 1500,  required: { message: 'Lời nhắn là bắt buộc' } });

    // Submit, Next button
    this.showSuccess = ko.observable(false);
	this.sendSuccess = ko.observable(false);

    this.Submit = function () {
		if(viewModel.sendSuccess() == false) {
			if (viewModel.errors().length == 0) {
				// Ajax submit
				$.ajax({
					type: "POST",
					url: "/Home/ContactUs",
					data: {
						"Fullname": viewModel.Fullname(),
						"Email": viewModel.Email(),
						"Phone": viewModel.Phone(),
						"Message": viewModel.Message()
					},
					dataType: "json",
					success: function (data, textStatus, jqXHR) {
						if (data == null || data == '') {
							viewModel.showSuccess(true);
							viewModel.sendSuccess(true);
						}
					},
					error: function (xhr, status, error) {
					}
				});
			}
			else {
				viewModel.errors.showAllMessages();
				return false;
			}
		}
    }

    this.Reset = function () {
        this.showSuccess(false);
        this.Fullname('');
        this.Email('');
        this.Phone('');
        this.Message('');
    }
};

var contactForm = document.getElementById("contactForm");
if (contactForm != undefined && contactForm != null) {
    viewModel.errors = ko.validation.group(viewModel);
    ko.validation.rules.pattern.message = 'Invalid.';
    ko.applyBindings(viewModel, contactForm);
}