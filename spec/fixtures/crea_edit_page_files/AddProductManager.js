/* global incubart */

var AddProductManager = function (options) {
    this.options = options;
};

AddProductManager.prototype = {

    unitPriceSelector: '[data-role="unit-price"]',
    volumePercentageSelector: '[data-role="volume-percentage"]',
    volumeUnitSelector: '[data-role="volume-unit"]',
    volumeDiscountInfoTemplateSelector: '[data-template="volume-discount-info"]',
    volumeDiscountInfoSelector: '[data-role="volume-discount-info"]',
    originCountrySelector: '[data-role="origin-country"]',
    originProvinceTemplateSelector: '[data-template="origin-province-select"]',
    originProvinceSelector: '[data-role="origin-province"]',
    originProvinceContainer: '[data-role="origin-province-container"]',
    isValidated: false,
    unitPriceDiscountValue: null,

    init: function () {
        this.plugEvents();
        this.renderOriginProvinceSelect();
    },

    plugEvents: function () {
        $(this.unitPriceSelector).on('focusout', $.proxy(this.validateFields, this));
        $(this.volumePercentageSelector).on('focusout', $.proxy(this.validateFields, this));
        $(this.volumeUnitSelector).on('change', $.proxy(this.validateFields, this));
        $(this.originCountrySelector).on('change', $.proxy(this.renderOriginProvinceSelect, this));
        $(this).on('fieldsValidated', $.proxy(this.calculateVolumeDiscount, this));
        $(this).on('discountCalculated', $.proxy(this.showVolumeDiscountInformation, this));
        $(this).on('fieldsUnvalidated', $.proxy(this.hideVolumeDiscountInformation, this));

    },

    /* Validates fields values before any calculation */
    validateFields: function () {
        this.unitPriceValue = $(this.unitPriceSelector).val();
        this.volumePercentageValue = $(this.volumePercentageSelector).val();
        var volumeUnitValue = $(this.volumeUnitSelector).val();

        if (this.isNumeric(this.unitPriceValue) && this.isNumeric(this.volumePercentageValue) && this.isNumeric(volumeUnitValue)) {
            this.isValidated = true;
        }

        if (!(this.volumePercentageValue > 4 && this.volumePercentageValue < 100)) {
            this.isValidated = false;
        }

        if (this.volumePercentageValue != parseInt(this.volumePercentageValue)) {
            this.isValidated = false;
        }

        if (true === this.isValidated) {
            $(this).trigger('fieldsValidated');
        } else {
            $(this).trigger('fieldsUnvalidated');
        }
    },

    /* Should be moved to a generic helper in a near future */
    isNumeric: function (value) {
        return (parseInt(value, 10) > 0);
    },

    /* Calculate volume discount */
    calculateVolumeDiscount: function () {
        this.unitPriceDiscountValue = this.unitPriceValue - (0.01 * this.volumePercentageValue * this.unitPriceValue);
        this.unitPriceDiscountValue = this.unitPriceDiscountValue.toFixed(2);
        $(this).trigger('discountCalculated');
    },

    showVolumeDiscountInformation: function () {
        var data = {
            unitPriceOld: this.unitPriceValue,
            unitPriceNew: this.unitPriceDiscountValue
        };
        var that = this;
        incubart.ui.Templater.render($(this.volumeDiscountInfoTemplateSelector), data, function (err, out) {
            $(that.volumeDiscountInfoSelector).html(out).show();
        });
    },

    hideVolumeDiscountInformation: function () {
        $(this.volumeDiscountInfoSelector).hide();
    },

    renderOriginProvinceSelect: function() {
        if('FR' === $(this.originCountrySelector).val()) {
            this.showOriginProvinceSelect($(this.originCountrySelector).val());
        } else {
            this.hideOriginProvinceSelect();
        }
    },

    showOriginProvinceSelect: function(countryId) {
        var data = this.getOriginProvinceData(countryId);
        if(null !== data) {
            data['selectedProvinceId'] = this.options.selectedProvinceId;
        }
        var that = this;
        incubart.ui.Templater.render($(this.originProvinceTemplateSelector), data, function (err, out) {
            $(that.originProvinceSelector).html(out);
            $(that.originProvinceContainer).show();
        });
    },

    getOriginProvinceData: function(countryId)
    {
        var result = null;
        $.ajax({
          type: "POST",
          url: this.options.ajaxUrl,
          async: false,
          data: {
              controller: this.options.provinceController,
              method: "getByCountryId",
              methodParams : [{
                  countryId: countryId
              }]
          },
          success : function(data) {
              result = JSON.parse(data);
          }
        });
        return result;
    },

    hideOriginProvinceSelect: function() {
        $(this.originProvinceContainer).hide();
        /* Remove the selection if there were a previous selection */
        $(this.originProvinceSelector).val([]);
    }

};
