package request

import (
	"errors"
	"github.com/gin-gonic/gin"
	ut "github.com/go-playground/universal-translator"
	"gopkg.in/go-playground/validator.v9"
	"logic/config"
	"strings"
)

type LoginInput struct {
	Username string `form:"username" validate:"required"`
	Passwd string `form:"password" validate:"required"`
}

func (o *LoginInput) BindingValidParams(c *gin.Context) error {
	//绑定数据
	if err := c.ShouldBind(o); err != nil {
		return err
	}
	v := c.Value("trans")
	trans, ok := v.(ut.Translator)
	if !ok {
		trans, _ = config.Uni.GetTranslator("zh")
	}
	////验证器注册翻译器
	//e := zh_translations.RegisterDefaultTranslations(public.Validate, trans)
	//if e != nil {
	//	return e
	//}
	//验证
	err := config.Validate.Struct(o)
	if err != nil {
		sliceErrs := []string{}
		for _, e := range err.(validator.ValidationErrors) {

			sliceErrs = append(sliceErrs, e.Translate(trans))
		}
		return errors.New(strings.Join(sliceErrs, ","))
	}
	return nil
}